use axum::{
    extract::Query,
    routing::get,
    Router,
    response::IntoResponse,
};
use regex::Regex;
use serde::Deserialize;
use std::net::SocketAddr;

// Estructura para leer el parámetro '?n='
#[derive(Deserialize)]
struct Params {
    n: Option<u32>,
}

// Función auxiliar para consumir SOAP
async fn call_soap(n: u32) -> String {
    // Usamos r#""# para escribir strings con comillas dobles sin problemas
    let xml = format!(
        r#"<?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Body>
            <NumberToWords xmlns="http://www.dataaccess.com/webservicesserver/">
              <ubiNum>{}</ubiNum>
            </NumberToWords>
          </soap:Body>
        </soap:Envelope>"#, n
    );

    let client = reqwest::Client::new();
    let res = client.post("https://www.dataaccess.com/webservicesserver/NumberConversion.wso")
        .header("Content-Type", "text/xml")
        .body(xml)
        .send()
        .await;

    if let Ok(response) = res {
        if let Ok(text) = response.text().await {
            // Regex flexible como el que usamos en C++
            let re = Regex::new(r"NumberToWordsResult>([^<]+)</").unwrap();
            if let Some(caps) = re.captures(&text) {
                // Extraemos la palabra y le quitamos los saltos de línea basura
                return caps.get(1).map_or("Error".to_string(), |m| m.as_str().trim().to_string());
            }
        }
    }
    "Error en el servidor SOAP".to_string()
}

// 1. SOAP Consumo
async fn clisoap1(Query(params): Query<Params>) -> impl IntoResponse {
    let n = params.n.unwrap_or(10);
    call_soap(n).await
}

// 2. SOAP + Traducción
async fn clisoap2(Query(params): Query<Params>) -> impl IntoResponse {
    let n = params.n.unwrap_or(10);
    let word = call_soap(n).await;
    
    // Limpiamos espacios para la URL de Google
    let safe_word = word.replace(" ", "%20");
    let url = format!("https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=es&dt=t&q={}", safe_word);
    
    let res = reqwest::get(&url).await;
    if let Ok(response) = res {
        if let Ok(text) = response.text().await {
            // Extracción rápida del JSON de Google
            if let Some(start) = text.find('\"') {
                if let Some(end) = text[start+1..].find('\"') {
                    return text[start+1..start+1+end].to_string();
                }
            }
        }
    }
    "Error en traducción".to_string()
}

// 3. Nativo
async fn conintl(Query(params): Query<Params>) -> impl IntoResponse {
    let n = params.n.unwrap_or(10);
    let nums = ["cero", "uno", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve", "diez"];
    
    if n <= 10 {
        nums[n as usize].to_string()
    } else {
        "Fuera de rango".to_string()
    }
}

// Punto de entrada asíncrono
#[tokio::main]
async fn main() {
    let app = Router::new()
        .route("/clisoap1", get(clisoap1))
        .route("/clisoap2", get(clisoap2))
        .route("/conintl", get(conintl));

    let addr = SocketAddr::from(([127, 0, 0, 1], 8080));
    println!("Servidor Rust corriendo en http://localhost:8080...");
    
    let listener = tokio::net::TcpListener::bind(addr).await.unwrap();
    axum::serve(listener, app).await.unwrap();
}