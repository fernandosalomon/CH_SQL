const personas = [
  ["Juan","Pérez"],
  ["Carlos","Gómez"],
  ["Luis","Fernández"],
  ["Pedro","López"],
  ["Mario","Rodríguez"],
  ["Diego","Martínez"],
  ["Pablo","Sánchez"],
  ["Nicolás","Romero"],
  ["Sergio","Torres"],
  ["Martín","Ruiz"],
  ["Andrés","Álvarez"],
  ["Federico","Morales"],
  ["Javier","Herrera"],
  ["Sebastián","Castro"],
  ["Gonzalo","Ortiz"],
  ["Lucas","Silva"],
  ["Matías","Rojas"],
  ["Agustín","Benítez"],
  ["Franco","Medina"],
  ["Emiliano","Arias"],
  ["Facundo","Acosta"],
  ["Ramiro","Navarro"],
  ["Leandro","Molina"],
  ["Iván","Domínguez"],
  ["Bruno","Cabrera"],
  ["Tomás","Vega"],
  ["Alejandro","Paz"],
  ["Mariano","Figueroa"],
  ["Hernán","Peralta"],
  ["Cristian","Godoy"],
  ["Ricardo","Correa"],
  ["Daniel","Luna"],
  ["Ezequiel","Campos"],
  ["Nahuel","Reyes"],
  ["Guillermo","Ibarra"],
  ["Ignacio","Flores"],
  ["Manuel","Roldán"],
  ["Jonathan","Miranda"],
  ["Esteban","Ponce"],
  ["Axel","Escobar"],
  ["Rodrigo","Vázquez"],
  ["Alan","Quiroga"],
  ["Maximiliano","Ferreyra"],
  ["Luciano","Sosa"],
  ["Adrián","Villalba"],
  ["Walter","Ojeda"],
  ["Marcos","Bravo"],
  ["Cristóbal","Toledo"],
  ["Christian","Aguirre"],
  ["Patricio","Giménez"],
  ["Hugo","Méndez"],
  ["Claudio","Cortés"],
  ["Rubén","Valdez"],
  ["Pablo","Ledesma"],
  ["Fabián","Núñez"],
  ["Oscar","Coronel"],
  ["Raúl","Salinas"],
  ["Mauricio","Bustos"],
  ["Horacio","Gallardo"],
  ["Víctor","Cáceres"],
  ["Alberto","Páez"],
  ["Edgardo","Serrano"],
  ["Fernando","Montoya"],
  ["Joaquín","Cardozo"],
  ["Álvaro","Barrios"],
  ["Damián","Franco"],
  ["Simón","Mansilla"],
  ["Kevin","Córdoba"],
  ["Brian","Leiva"],
  ["Matías","Villagra"],
  ["Alexis","Suárez"],
  ["Gastón","Zárate"],
  ["Leonardo","Arce"],
  ["Cristopher","Muñoz"],
  ["Santiago","Paredes"],
  ["Facundo","Lencina"],
  ["Emanuel","Ayala"],
  ["Julio","Báez"],
  ["César","Oliva"],
  ["Roberto","Moyano"],
  ["Nelson","Cano"],
  ["Miguel","Rivero"],
  ["Ariel","Carrizo"],
  ["Lautaro","Nieto"],
  ["Ulises","Funes"],
  ["Renzo","Riquelme"],
  ["Benjamín","Poblete"],
  ["Thiago","Sepúlveda"],
  ["Valentín","Delgado"],
  ["Francesco","Rinaldi"],
  ["Enzo","Ferrari"],
  ["Matheo","Bianchi"],
  ["Gino","Moretti"],
  ["Paolo","Ricci"],
  ["Dylan","Almada"],
  ["Kevin","Patiño"],
  ["Jonathan","Valenzuela"],
  ["Cristian","Saavedra"],
  ["Rodrigo","Latorre"],
  ["Néstor","Cuello"],
  ["Guido","Santillán"],
  ["Brayan","Ponce"],
  ["Jesús","Moreno"],
  ["Ernesto","Prieto"],
  ["Samuel","Campos"],
  ["Tomás","Ibáñez"],
  ["Lucas","Quinteros"],
  ["Ramón","Bermúdez"],
  ["Marcelo","Tevez"],
  ["Félix","Andrada"],
  ["Ricardo","Cámpora"],
  ["Julian","Casas"],
  ["Matías","Insúa"],
  ["Santino","Palacios"],
  ["Elias","Frías"],
  ["Iván","Tapia"],
  ["Gaspar","Ramos"],
  ["Nicolás","Bustamante"],
  ["León","Salvatierra"],
  ["Thierry","Fontana"],
  ["Alan","Montes"],
  ["Jorge","Pineda"],
  ["Oscar","Vallejos"],
  ["Darío","Santana"],
  ["Piero","Lombardi"],
  ["Bruno","Marquez"],
  ["Estanislao","Acuña"],
  ["Felipe","Zamora"],
  ["Ramiro","Carballo"],
  ["Héctor","Farias"],
  ["Cristóbal","Villafañe"],
  ["Efraín","Lucero"],
  ["Adolfo","Ríos"],
  ["Bautista","Corvalán"],
  ["Teo","Sambucetti"],
  ["Franco","Spinelli"],
  ["Milton","Velázquez"],
  ["Lisandro","Albornoz"],
  ["Noah","Perdomo"],
  ["Elías","Barone"],
  ["Simón","Cifuentes"],
  ['Juan', 'Pérez'],
  ['Carlos', 'González'],
  ['Lucas', 'Fernández'],
  ['Martín', 'Rodríguez'],
  ['Nicolás', 'López'],
  ['Diego', 'Martínez'],
  ['Pablo', 'García'],
  ['Federico', 'Suárez'],
  ['Matías', 'Romero']
];

function randomDate(start, end) {
  // Esta función devuelve una fecha aleatoria entre las fechas "start" y "end".
  const startTime = new Date(start).getTime();
  const endTime = new Date(end).getTime();

  const randomTime = startTime + Math.random() * (endTime - startTime);

  return new Date(randomTime).toISOString().split('T')[0];
}

function randomDni(){
    // Esta función devuelve un número aleatorio entre 20000000 y 50000000 para simular un número de DNI.

    let randomNumber = 0;

    while(randomNumber < 20000000 || randomNumber > 50000000){
        randomNumber = (Math.random()*100000000).toFixed(0);
    }

    return randomNumber;
}

function positions(index){
    const posiciones = ['Arquero', 
                        'Arquero', 
                        'Defensa', 
                        'Defensa', 
                        'Defensa',
                        'Defensa', 
                        'Mediocampista',
                        'Mediocampista',
                        'Mediocampista',
                        'Mediocampista',
                        'Mediocampista',
                        'Delantero',
                        'Delantero',
                        'Delantero',
                        'Delantero'];
                   
    
    return posiciones[index % 15];
}

function crearListaJugadores() {

    personas.map((persona, index) => {
        const idEquipo = Math.floor(index / 15) + 1;
        const dataJugador = [
            `('${persona[0]}'`,
            `'${persona[1]}'`,
            randomDni(),
            `'${randomDate('1980-01-01','2012-01-01')}'`,
            `'${positions(index)}'`,
            Math.floor(Math.random()*100),
            `${idEquipo}),`
        ];
        console.log(dataJugador.join(','));
    });
}

crearListaJugadores();