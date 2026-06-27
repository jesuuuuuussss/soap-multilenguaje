use Mojolicious::Lite -signatures;
use SOAP::Lite;
use Lingua::ES::Numeros;

# 1. Consumir SOAP público
# http://localhost:8000/clisoap1?n=10
get '/clisoap1' => sub ($c) {
    my $numero = $c->param('n') || 10;
    
    my $soap = SOAP::Lite->service('http://www.dataaccess.com/webservicesserver/NumberConversion.wso?WSDL');
    
    my $resultado = $soap->NumberToWords($numero);
    
    $c->render(text => $resultado);
};

# 2. Consumir SOAP y Traducir de inglés a español
# http://localhost:8000/clisoap2?n=10
get '/clisoap2' => sub ($c) {
    my $numero = $c->param('n') || 10;
    
    # 1. Obtener número en inglés vía SOAP
    my $soap = SOAP::Lite->service('http://www.dataaccess.com/webservicesserver/NumberConversion.wso?WSDL');
    my $texto_ingles = $soap->NumberToWords($numero);
    s
    my $url = Mojo::URL->new('https://translate.googleapis.com/translate_a/single');
    $url->query(client => 'gtx', sl => 'en', tl => 'es', dt => 't', q => $texto_ingles);
    
    my $res = $c->app->ua->get($url)->result;
    
    my $resultado_espanol = "Error en traducción";
    if ($res->is_success) {
        my $json = $res->json;
        $resultado_espanol = $json->[0][0][0]; 
    }
    
    $c->render(text => $resultado_espanol);
};

# 3. Convertir número a letras con librería nativa
# http://localhost:8000/conintl?n=10

helper numero_a_letras => sub ($c, $num) {
    my @unidades = (
        'cero', 'uno', 'dos', 'tres', 'cuatro', 'cinco', 'seis', 'siete', 'ocho', 'nueve', 'diez', 
        'once', 'doce', 'trece', 'catorce', 'quince', 'dieciséis', 'diecisiete', 'dieciocho', 'diecinueve', 'veinte'
    );
    
    if ($num >= 0 && $num <= 20) {
        return $unidades[$num];
    } else {
        return "El número $num está fuera del rango básico (0-20) configurado en el código base.";
    }
};

get '/conintl' => sub ($c) {
    my $numero = $c->param('n') || 10;
    
    my $resultado = $c->numero_a_letras($numero);
    
    $c->render(text => $resultado);
};

app->start;