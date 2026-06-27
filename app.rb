require 'sinatra'
require 'savon'
require 'google_translate_diff'
require 'numbers_and_words'

# Configurar el puerto para que sea igual al de tu ejemplo en PHP
set :port, 8000

# 1. Consumir SOAP público
# http://localhost:8000/clisoap1?n=10
get '/clisoap1' do
  numero = params['n'] || 10
  
  # Inicializar cliente SOAP
 cliente = Savon.client(
    wsdl: 'http://www.dataaccess.com/webservicesserver/NumberConversion.wso?WSDL',
    adapter: :httpclient,
    open_timeout: 60,
    read_timeout: 60,
    ssl_verify_mode: :none
  )
  
  respuesta = cliente.call(:number_to_words, message: { 'ubiNum' => numero })
  
  respuesta.body[:number_to_words_response][:number_to_words_result]
end

# 2. Consumir SOAP y Traducir de inglés a español
# http://localhost:8000/clisoap2?n=10
get '/clisoap2' do
  numero = params['n'] || 10
  
  cliente = Savon.client(
    wsdl: 'http://www.dataaccess.com/webservicesserver/NumberConversion.wso?WSDL',
    adapter: :httpclient,
    open_timeout: 60,
    read_timeout: 60,
    ssl_verify_mode: :none
  )
  respuesta = cliente.call(:number_to_words, message: { 'ubiNum' => numero })
  texto_ingles = respuesta.body[:number_to_words_response][:number_to_words_result]
  
  traductor = GoogleTranslateDiff::LinearTranslator.new('en', 'es')
  resultado_espanol = traductor.translate(texto_ingles)
  
  resultado_espanol
end

# 3. Convertir número a letras con librería nativa
# http://localhost:8000/conintl?n=10
get '/conintl' do
  numero = params['n'].to_i || 10

  I18n.locale = :es
  
  numero.to_words
end