DROP SCHEMA IF EXISTS torneo_futbol;
CREATE SCHEMA torneo_futbol;
USE torneo_futbol;

CREATE TABLE responsables_equipos(
	id_responsable INT AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    dni INT NOT NULL,
    fecha_nacimiento DATE,
    email VARCHAR(50) UNIQUE NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_responsable)
);

CREATE TABLE equipos(
	id_equipo INT AUTO_INCREMENT,
    id_responsable INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
	PRIMARY KEY (id_equipo),
    FOREIGN KEY (id_responsable) REFERENCES responsables_equipos(id_responsable)
);

CREATE TABLE jugadores(
	id_jugador INT AUTO_INCREMENT,
	id_equipo INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    dni INT NOT NULL,
    fecha_nacimiento DATE,
    posicion VARCHAR(50),
    numero_camiseta INT NOT NULL,
    PRIMARY KEY (id_jugador),
    FOREIGN KEY (id_equipo) REFERENCES equipos(id_equipo)
);

CREATE TABLE arbitros(
	id_arbitro INT AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_arbitro)
);

CREATE TABLE canchas(
	id_cancha INT AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    direccion VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(50) UNIQUE,
    PRIMARY KEY (id_cancha)
);

CREATE TABLE reservas_canchas(
	id_reserva INT AUTO_INCREMENT,
    id_cancha INT NOT NULL,
    nro_reserva VARCHAR(25) NOT NULL,
    fecha_reserva DATETIME NOT NULL,
    precio DECIMAL(7,2) NOT NULL,
    PRIMARY KEY (id_reserva),
    FOREIGN KEY (id_cancha) REFERENCES canchas(id_cancha)
);

CREATE TABLE categorias(
	id_categoria INT AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY (id_categoria)
);

CREATE TABLE torneos(
	id_torneo INT AUTO_INCREMENT,
    id_categoria INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_final DATE,
    estado BOOL NOT NULL,
    PRIMARY KEY (id_torneo),
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE inscripciones(
	id_inscripcion INT AUTO_INCREMENT,
    id_equipo INT NOT NULL,
    id_torneo INT NOT NULL,
	fecha_inscripcion DATE NOT NULL,
    pago DECIMAL(7,2) NOT NULL,
    PRIMARY KEY (id_inscripcion),
    FOREIGN KEY (id_equipo) REFERENCES equipos(id_equipo),
    FOREIGN KEY (id_torneo) REFERENCES torneos(id_torneo)
);

CREATE TABLE fases(
	id_fase INT AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY (id_fase)
);

CREATE TABLE partidos(
	id_partido INT AUTO_INCREMENT,
    id_fase INT,
    id_equipo_local INT NOT NULL,
    id_equipo_visitante INT NOT NULL,
    id_cancha INT NOT NULL,
    id_reserva INT,
    id_arbitro INT NOT NULL,
    id_torneo INT,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    PRIMARY KEY (id_partido),
    FOREIGN KEY (id_fase) REFERENCES fases(id_fase),
    FOREIGN KEY (id_equipo_local) REFERENCES equipos(id_equipo),
    FOREIGN KEY (id_equipo_visitante) REFERENCES equipos(id_equipo),
    FOREIGN KEY (id_cancha) REFERENCES canchas(id_cancha),
    FOREIGN KEY (id_reserva) REFERENCES reservas_canchas(id_reserva),
    FOREIGN KEY (id_arbitro) REFERENCES arbitros(id_arbitro),
    FOREIGN KEY (id_torneo) REFERENCES torneos(id_torneo)
);

CREATE TABLE resultado_partidos(
	id_resultado INT AUTO_INCREMENT,
    id_partido INT NOT NULL UNIQUE,
    id_figura_partido INT,
    goles_local INT NOT NULL,
    goles_visitante INT NOT NULL,
    decidido_penales BOOL NOT NULL,
    goles_penales_local INT,
    goles_penales_visitante INT,
    ganador ENUM('L', '0', 'V') NOT NULL, 
    PRIMARY KEY (id_resultado),
    FOREIGN KEY (id_partido) REFERENCES partidos(id_partido),
	FOREIGN KEY (id_figura_partido) REFERENCES jugadores(id_jugador)
);

CREATE TABLE goles(
	id_gol INT AUTO_INCREMENT,
    id_partido INT NOT NULL,
    id_jugador INT NOT NULL,
    tipo BOOL NOT NULL,
    tiempo_min INT NOT NULL,
    PRIMARY KEY (id_gol),
    FOREIGN KEY (id_partido) REFERENCES partidos(id_partido),
    FOREIGN KEY (id_jugador) REFERENCES jugadores(id_jugador)
);

CREATE TABLE tarjetas(
	id_tarjeta INT AUTO_INCREMENT,
    id_jugador INT NOT NULL,
    id_partido INT NOT NULL,
    id_arbitro INT NOT NULL,
    tipo_tarjeta ENUM('A', 'R') NOT NULL,
    tiempo_min INT NOT NULL,
    PRIMARY KEY (id_tarjeta),
    FOREIGN KEY (id_jugador) REFERENCES jugadores(id_jugador),
    FOREIGN KEY (id_partido) REFERENCES partidos(id_partido),
    FOREIGN KEY (id_arbitro) REFERENCES arbitros(id_arbitro)
);

-- VISTAS 

-- Vista 1: Permite ver los resultados de partidos que ya han sido jugados.
DROP VIEW IF EXISTS vw_partidos_resultados;
CREATE VIEW vw_partidos_resultados AS
SELECT 	p.fecha AS 'Fecha',
        p.hora AS 'Hora',
        el.nombre AS 'Equipo Local',
        ev.nombre AS 'Equipo Visitante',
        CONCAT(rp.goles_local, '-', rp.goles_visitante) AS 'Resultado',
        t.nombre AS 'Torneo'
FROM partidos AS p
INNER JOIN equipos AS el
	ON el.id_equipo = p.id_equipo_local
INNER JOIN equipos AS ev
	ON ev.id_equipo = p.id_equipo_visitante
INNER JOIN torneos AS t
	ON t.id_torneo = p.id_torneo
LEFT JOIN resultado_partidos AS rp
	ON rp.id_partido = p.id_partido
WHERE t.estado = 0;

-- Vista 2: Tabla de los equipos inscriptos en cada torneo.
DROP VIEW IF EXISTS vw_equipos_torneos;
CREATE VIEW vw_equipos_torneos AS
SELECT 	t.nombre AS 'Torneo',
		e.nombre AS 'Equipo',
		i.fecha_inscripcion AS 'Fecha de Inscripción',
		i.pago AS 'Pago'
FROM inscripciones i
JOIN equipos e ON i.id_equipo = e.id_equipo
JOIN torneos t ON i.id_torneo = t.id_torneo;

-- Vista 3: Número de tarjetas amarillas y rojas por jugador.
DROP VIEW IF EXISTS vw_tarjetas_jugador;
CREATE VIEW vw_tarjetas_jugador AS
SELECT 
    j.nombre AS 'Nombre',
    j.apellido AS 'Apellido',
    e.nombre AS 'Equipo',
    COUNT(CASE WHEN t.tipo_tarjeta = 'A' THEN 1 END) AS 'Amarillas',
    COUNT(CASE WHEN t.tipo_tarjeta = 'R' THEN 1 END) AS 'Rojas'
FROM tarjetas t
INNER JOIN jugadores AS j 
	ON t.id_jugador = j.id_jugador
INNER JOIN equipos AS e
	ON j.id_equipo = e.id_equipo
GROUP BY j.id_jugador;

-- Vista 4: Número de partidos jugados en cada cancha.
DROP VIEW IF EXISTS vw_uso_canchas;
CREATE VIEW vw_uso_canchas AS
SELECT 
    c.nombre,
    COUNT(p.id_partido) AS 'Partidos Jugados'
FROM canchas c
LEFT JOIN partidos p ON c.id_cancha = p.id_cancha
GROUP BY c.id_cancha;

-- Vista 5: Número total de goles por torneo de los jugadores.
DROP VIEW IF EXISTS vw_goleadores_torneo;
CREATE VIEW vw_goleadores_torneo AS
SELECT 
    t.nombre AS 'Torneo',
    j.nombre AS 'Nombre',
    j.apellido 'Apellido',
    e.nombre AS 'Equipo',
    COUNT(g.id_gol) AS 'Nro de goles'
FROM goles g
JOIN jugadores j ON g.id_jugador = j.id_jugador
JOIN equipos e ON j.id_equipo = e.id_equipo
JOIN partidos p ON g.id_partido = p.id_partido
JOIN torneos t ON p.id_torneo = t.id_torneo
GROUP BY t.nombre, j.id_jugador
ORDER BY COUNT(g.id_gol) DESC;

-- Funciones

-- Función 1: Devuelve el número total de goles realizado por un jugador a lo largo de todos los torneos.
DELIMITER //

CREATE FUNCTION f_total_goles_jugador(p_id_jugador INT)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE n_goles INT;
    SELECT COUNT(*) INTO n_goles
    FROM goles AS g
	LEFT JOIN jugadores AS j
		ON g.id_jugador = j.id_jugador
    WHERE j.id_jugador = p_id_jugador;
    RETURN n_goles;
END //

DELIMITER ;


-- Stored Procedures

-- Procedimiento almacenado 1: Permite registrar el resultado de un partido en la base de datos.
DELIMITER //

CREATE PROCEDURE sp_registrar_resultado(
    p_id_partido INT,
    p_goles_local INT,
    p_goles_visitante INT,
    p_penales BOOL
)
BEGIN
    INSERT INTO resultado_partidos
	(id_partido, goles_local, goles_visitante, ganador, decidido_penales)
    VALUES (
        p_id_partido,
        p_goles_local,
        p_goles_visitante,
        CASE
            WHEN p_goles_local > p_goles_visitante THEN 'L'
            WHEN p_goles_local < p_goles_visitante THEN 'V'
            ELSE '0'
        END,
        p_penales
    );
END //

DELIMITER ;

-- Procedimiento almacenado 2: Permite inscribir a un equipo en la base de datos.
DELIMITER //
CREATE PROCEDURE sp_inscribir_equipo( 
								p_id_equipo INT, 
                                p_id_torneo INT, 
                                p_pago DECIMAL(7,2) 
								) 
BEGIN 
	INSERT INTO inscripciones (id_equipo, id_torneo, fecha_inscripcion, pago) VALUES 
    (p_id_equipo, p_id_torneo, CURDATE(), p_pago); 
END //

DELIMITER ;
