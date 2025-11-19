CREATE SCHEMA IF NOT EXISTS torneo_futbol;
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
	PRIMARY KEY (id_equipo),
    FOREIGN KEY (id_responsable) REFERENCES responsables_equipos(id_responsable)
);

CREATE TABLE jugadores(
	id_jugador INT AUTO_INCREMENT,
	id_equipo INT NOT NULL UNIQUE,
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
    nro_reserva INT NOT NULL,
    fecha_reserva DATETIME NOT NULL,
    precio DECIMAL(5,2) NOT NULL,
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
    pago DECIMAL(5,2) NOT NULL,
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
    id_partido INT NOT NULL,
    id_figura_partido INT,
    goles_local INT NOT NULL,
    goles_visitante INT NOT NULL,
    ganador ENUM('L', '0', 'V') NOT NULL, 
    decidido_penales BOOL NOT NULL,
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



