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

## 4. .NET 10

### Ejecución
1. Entrar a la carpeta: `cd SoapApiNet10`
2. Ejecutar: `dotnet run`

* **EndPoint 1:** `http://localhost:5000/clisoap1?n=10`
* **EndPoint 2:** `http://localhost:5000/clisoap2?n=10`
* **EndPoint 1:** `http://localhost:5000/conintl?n=10`

## 5. Golang

### Ejecución
1. Entrar a la carpeta: `cd GoSoapApi`
2. Ejecutar: `go run main.go`

* **EndPoint 1:** `http://localhost:8000/clisoap1?n=10`
* **EndPoint 2:** `http://localhost:8000/clisoap2?n=10`
* **EndPoint 3:** `http://localhost:8000/conintl?n=10`

## 6. Java

Implementación desarrollada con **Spring Boot**.

### Ejecución
1. Entrar a la carpeta: `cd JavaSoapApi`
2. Ejecutar: `mvn spring-boot:run`

* **EndPoint 1:** `http://localhost:8080/clisoap1?n=10`
* **EndPoint 2:** `http://localhost:8080/clisoap2?n=10`
* **EndPoint 3:** `http://localhost:8080/conintl?n=10`

## 7. C++

### Ejecución
1. Entrar a la carpeta: `cd CppSoapApi`
2. Compilar: `g++ main.cpp -o soap_api.exe -lws2_32`
3. Ejecutar: `soap_api.exe`

* **EndPoint 1:** `http://localhost:8080/clisoap1?n=10`
* **EndPoint 2:** `http://localhost:8080/clisoap2?n=10`
* **EndPoint 3:** `http://localhost:8080/conintl?n=10`