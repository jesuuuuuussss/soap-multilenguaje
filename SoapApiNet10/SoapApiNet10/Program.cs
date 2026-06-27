using Microsoft.AspNetCore.Mvc;
using System.ServiceModel;
using System.Xml.Linq;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// 1. SOAP Consumo
app.MapGet("/clisoap1", async (int n) => {
    // Para SOAP en .NET, lo ideal es agregar una "Connected Service" (WSDL), 
    // pero para este ejemplo rápido, haremos una petición HTTP directa al XML del servicio.
    var result = await FetchSoapNumberToWords(n);
    return Results.Text(result);
});

// 2. SOAP + Traducción
app.MapGet("/clisoap2", async (int n) => {
    var textoIngles = await FetchSoapNumberToWords(n);
    // Traducción vía API de Google
    var url = $"https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=es&dt=t&q={Uri.EscapeDataString(textoIngles)}";
    using var client = new HttpClient();
    var response = await client.GetStringAsync(url);
    // Parsing simplificado del JSON de Google
    return Results.Text(response.Split('"')[1]); 
});

// 3. Nativo (Conversión a letras)
app.MapGet("/conintl", (int n) => {
    // Lógica nativa sencilla (puedes ampliarla)
    string[] unidades = { "cero", "uno", "diez" }; // Ejemplo base
    return Results.Text(n <= 2 ? unidades[n] : "diez");
});

async Task<string> FetchSoapNumberToWords(int n) {
    using var client = new HttpClient();
    var soapEnvelope = $@"<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:web='http://www.dataaccess.com/webservicesserver/'>
        <soapenv:Body>
            <web:NumberToWords>
                <web:ubiNum>{n}</web:ubiNum>
            </web:NumberToWords>
        </soapenv:Body>
    </soapenv:Envelope>";
    
    var content = new StringContent(soapEnvelope, System.Text.Encoding.UTF8, "text/xml");
    var response = await client.PostAsync("https://www.dataaccess.com/webservicesserver/NumberConversion.wso", content);
    var xmlString = await response.Content.ReadAsStringAsync();
    return XDocument.Parse(xmlString).Descendants().FirstOrDefault(d => d.Name.LocalName == "NumberToWordsResult")?.Value ?? "Error";
}

app.Run();