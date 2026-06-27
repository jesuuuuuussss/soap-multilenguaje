const express = require('express');
const soap = require('soap');
const writtenNumber = require('written-number');

const app = express();
const port = 8000;
const wsdlUrl = 'https://www.dataaccess.com/webservicesserver/NumberConversion.wso?WSDL';

// 1. Consumir SOAP público
// http://localhost:8000/clisoap1?n=10
app.get('/clisoap1', (req, res) => {
    const numero = req.query.n || 10;

    soap.createClient(wsdlUrl, (err, client) => {
        if (err) return res.status(500).send("Error al crear cliente SOAP");

        client.NumberToWords({ ubiNum: numero }, (err, result) => {
            if (err) return res.status(500).send("Error en la llamada SOAP");
            res.send(result.NumberToWordsResult);
        });
    });
});

// 2. Consumir SOAP y Traducir de inglés a español
// http://localhost:8000/clisoap2?n=10
app.get('/clisoap2', (req, res) => {
    const numero = req.query.n || 10;

    soap.createClient(wsdlUrl, (err, client) => {
        if (err) return res.status(500).send("Error al crear cliente SOAP");

        client.NumberToWords({ ubiNum: numero }, async (err, result) => {
            if (err) return res.status(500).send("Error en la llamada SOAP");
            
            const textoIngles = result.NumberToWordsResult.trim();
            
            try {
                const url = `https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=es&dt=t&q=${encodeURI(textoIngles)}`;
                const response = await fetch(url);
                const json = await response.json();
                
                const textoEspanol = json[0][0][0];
                res.send(textoEspanol);
            } catch (translateErr) {
                res.status(500).send("Error en la traducción");
            }
        });
    });
});

// 3. Convertir número a letras con librería nativa
// http://localhost:8000/conintl?n=10
app.get('/conintl', (req, res) => {
    const numero = parseInt(req.query.n) || 10;
    
    const resultado = writtenNumber(numero, { lang: 'es' });
    
    res.send(resultado);
});

app.listen(port, () => {
    console.log(`Servidor Node.js escuchando en http://localhost:${port}`);
});