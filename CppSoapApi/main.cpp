#include "httplib.h"
#include <iostream>
#include <string>
#include <regex>
#include <memory>
#include <stdexcept>

using namespace std;
using namespace httplib;

string exec(const string& cmd) {
    char buffer[128];
    string result = "";
    FILE* pipe = _popen(cmd.c_str(), "r");
    if (!pipe) throw runtime_error("Error al abrir pipe");
    
    while (fgets(buffer, sizeof(buffer), pipe) != NULL) {
        result += buffer;
    }
    _pclose(pipe);
    return result;
}

string call_soap(string n) {
    string xml = "<?xml version='1.0' encoding='utf-8'?> <soap:Envelope xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'> <soap:Body> <NumberToWords xmlns='http://www.dataaccess.com/webservicesserver/'> <ubiNum>" + n + "</ubiNum> </NumberToWords> </soap:Body> </soap:Envelope>";
    
    string cmd = "curl -s -X POST -H \"Content-Type: text/xml\" -d \"" + xml + "\" https://www.dataaccess.com/webservicesserver/NumberConversion.wso";
    
    string response = exec(cmd);
    
    smatch match;
    regex e("NumberToWordsResult>([^<]+)</");
    if (regex_search(response, match, e) && match.size() > 1) {
        return match.str(1);
    }
    
    return "Error. Respuesta del servidor: " + response;
}

int main() {
    Server svr;

    // 1. SOAP Consumo
    svr.Get("/clisoap1", [](const Request& req, Response& res) {
        string n = req.has_param("n") ? req.get_param_value("n") : "10";
        string result = call_soap(n);
        res.set_content(result, "text/plain");
    });

    // 2. SOAP + Traducción
    svr.Get("/clisoap2", [](const Request& req, Response& res) {
        string n = req.has_param("n") ? req.get_param_value("n") : "10";
        string word = call_soap(n);
        
        string safe_word = "";
        for (char c : word) {
            if (c == ' ') safe_word += "%20";
            else if (c == '\n' || c == '\r') continue;
            else safe_word += c;
        }
        
        string url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=es&dt=t&q=" + safe_word;
        string cmd = "curl -s \"" + url + "\"";
        string response = exec(cmd);
        
        size_t start = response.find("\"");
        size_t end = response.find("\"", start + 1);
        
        string translated = (start != string::npos && end != string::npos) 
                            ? response.substr(start + 1, end - start - 1) 
                            : "Error al traducir. Respuesta de curl: " + response;
        
        res.set_content(translated, "text/plain");
    });

    // 3. Nativo
    svr.Get("/conintl", [](const Request& req, Response& res) {
        string n_str = req.has_param("n") ? req.get_param_value("n") : "10";
        int n = stoi(n_str);
        string nums[] = {"cero", "uno", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve", "diez"};
        
        string result = (n >= 0 && n <= 10) ? nums[n] : "Fuera de rango";
        res.set_content(result, "text/plain");
    });

    cout << "Servidor C++ corriendo en http://localhost:8080..." << endl;
    svr.listen("localhost", 8080);
    
    return 0;
}