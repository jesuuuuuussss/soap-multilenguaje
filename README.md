"# soap-multilenguaje" 

## 1. Ruby

### Requisitos
* Ruby instalado.
* Ejecutar `bundle install` para instalar las dependencias (Sinatra, Savon, GoogleTranslateDiff, NumbersAndWords).

### Ejecución
Ejecutar el siguiente comando en la terminal:
`ruby app.rb`

* **Punto 1 (SOAP):** http://localhost:8000/clisoap1?n=10
* **Punto 2 (Traducción):** http://localhost:8000/clisoap2?n=10
* **Punto 3 (Nativo):** http://localhost:8000/conintl?n=10


## 2. Perl

### Requisitos
* Perl instalado (Strawberry Perl recomendado en Windows).
* Instalar dependencias ejecutando: `cpanm Mojolicious SOAP::Lite Lingua::ES::Numeros`

### Ejecución
Ejecutar el siguiente comando en la terminal para levantar el servidor web de desarrollo:
`morbo app.pl -l "http://*:8000"`

* **Punto 1 (SOAP):** http://localhost:8000/clisoap1?n=10
* **Punto 2 (Traducción):** http://localhost:8000/clisoap2?n=10
* **Punto 3 (Nativo):** http://localhost:8000/conintl?n=10

## 3. Node.js

### Requisitos
* Node.js instalado.
* Ejecutar `npm install` para descargar las dependencias.

### Ejecución
Ejecutar el siguiente comando en la terminal:
`node app.js`

* **Punto 1 (SOAP):** http://localhost:8000/clisoap1?n=10
* **Punto 2 (Traducción):** http://localhost:8000/clisoap2?n=10
* **Punto 3 (Nativo):** http://localhost:8000/conintl?n=10