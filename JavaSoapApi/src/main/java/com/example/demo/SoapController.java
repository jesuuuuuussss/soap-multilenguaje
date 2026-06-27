package com.ejemplo.demo;

import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

@RestController
public class SoapController {

    // 1. SOAP Consumo
    @GetMapping("/clisoap1")
    public String clisoap1(@RequestParam(defaultValue = "10") int n) {
        return callSoap(n);
    }

    // 2. SOAP + Traducción
    @GetMapping("/clisoap2")
    public String clisoap2(@RequestParam(defaultValue = "10") int n) {

        String texto = callSoap(n);

        RestTemplate restTemplate = new RestTemplate();

        String url =
                "https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=es&dt=t&q="
                        + texto;

        return restTemplate.getForObject(url, String.class);
    }

    // 3. Nativo
    @GetMapping("/conintl")
    public String conintl(@RequestParam(defaultValue = "10") int n) {

        String[] nums = {
                "cero", "uno", "dos", "tres", "cuatro",
                "cinco", "seis", "siete", "ocho", "nueve", "diez"
        };

        return (n >= 0 && n <= 10)
                ? nums[n]
                : "Número fuera de rango";
    }

    // Simulación SOAP
    private String callSoap(int n) {

        String[] nums = {
                "zero", "one", "two", "three", "four",
                "five", "six", "seven", "eight", "nine", "ten"
        };

        return (n >= 0 && n <= 10)
                ? nums[n]
                : "number out of range";
    }
}