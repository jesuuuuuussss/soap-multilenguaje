package main

import (
	"bytes"
	"fmt"
	"io"
	"net/http"
	"regexp" 
    "net/url"
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	// 1. SOAP Consumo
	r.GET("/clisoap1", func(c *gin.Context) {
		n := c.DefaultQuery("n", "10")
		result := callSoap(n)
		c.String(http.StatusOK, result)
	})

	// 2. SOAP + Traducción (Consumiendo API de Google)
	r.GET("/clisoap2", func(c *gin.Context) {
		n := c.DefaultQuery("n", "10")
		xmlResponse := callSoap(n) 
		
		re := regexp.MustCompile(`<NumberToWordsResult>(.*?)</NumberToWordsResult>`)
		matches := re.FindStringSubmatch(xmlResponse)
		
		if len(matches) < 2 {
			c.String(http.StatusInternalServerError, "No se pudo extraer el número del XML")
			return
		}
		
		cleanText := matches[1]
		
		encodedText := url.QueryEscape(cleanText)
		
		urlApi := fmt.Sprintf("https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=es&dt=t&q=%s", encodedText)
		
		resp, err := http.Get(urlApi)
		if err != nil {
			c.String(http.StatusInternalServerError, "Error llamando a Google")
			return
		}
		defer resp.Body.Close()
		
		body, _ := io.ReadAll(resp.Body)
		c.String(http.StatusOK, string(body))
	})

	// 3. Nativo
	r.GET("/conintl", func(c *gin.Context) {
		n := c.DefaultQuery("n", "10")
		c.String(http.StatusOK, "Diez (Logic: "+n+")")
	})

	r.Run(":8000")
}

func callSoap(n string) string {
    xml := fmt.Sprintf(`<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
        <NumberToWords xmlns="http://www.dataaccess.com/webservicesserver/">
          <ubiNum>%s</ubiNum>
        </NumberToWords>
      </soap:Body>
    </soap:Envelope>`, n)

    resp, err := http.Post("https://www.dataaccess.com/webservicesserver/NumberConversion.wso", "text/xml", bytes.NewBufferString(xml))
    if err != nil {
        return "Error conectando a SOAP: " + err.Error()
    }
    defer resp.Body.Close()

    body, err := io.ReadAll(resp.Body)
    if err != nil {
        return "Error leyendo respuesta SOAP"
    }
    return string(body)
}