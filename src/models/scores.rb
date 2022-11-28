require 'json'
require 'aws-sdk-dynamodb'

#Constant que contiene la instancia del cliente de Dynamo
DYNAMODB = Aws::DynamoDB::Client.new
#Constante que contiene el nombre de la tabla que va a ser usada
TABLE_NAME = 'scores'

# Son las constantes de los status posibles a regresar.
class HttpStatus
  #OK code
  OK = 200
  #created code
  CREATED = 201
  #bad request code
  BAD_REQUEST = 400
  #method not allowed code
  METHOD_NOT_ALLOWED = 405
end

# Crea la respuesta en forma de JSON para ser enviada.
#
# Parametro::
#   code:: el codigo https correspondiente 
#   body:: obtiene el body a entrgar
# returns:: la respuesta a enviar 
def make_response(code, body)
  {
    statusCode: code,
    headers: {
      "Content-Type" => "application/json; charset=utf-8"
    },
    body: JSON.generate(body)
  }
end

#Organiza los datos en diccionarios
#
# Parametro::
#   items:: los datos duros de la tabla
# returns:: la lista de elementos en un diccionario
def make_result_list(items)
  items.map do |item| {
      'nombre' => item['Username'],
      'score' => item['Right'].to_i
    }
  end
end

#Organiza los scores de mayor a menor
# Parametro:: 
#   items:: los datos duros de la tabla
# returns:: la lista organizada
def sort_items(items)
  items.sort! {|a, b| a['score'] <=> b['score']}
end

#Descarga los datos de la tabla, los ordena y produce el resultado
def get_scores
  items = DYNAMODB.scan(table_name: TABLE_NAME).items
  sort_items(items)
  make_result_list(items)
end

#Acomoda el body de la respuesta 
#Paramtro::
# body:: es el body de la respuesta, aqui se ordena
def parse_body(body)
  if body
    begin
      data = JSON.parse(body)
      data.key?('nombre') ? data : nil
    rescue JSON::ParserError
      nil
    end
  else
    nil
  end
end

#Sube el dato del score en la base de datos
#Parametro::
# body:: el body que recibio de una funcion post
def store_score_item(body)
  data = parse_body(body)
  if data
    DYNAMODB.put_item(table_name: TABLE_NAME, item: data)
    true
  else
    false
  end
end

#Es la funcion que maneja que hacer cuando recibimos un get
def handle_get
  make_response(HttpStatus::OK, get_scores)
end

#Es la funcion que maneja que hacer cuando recibimos un post
def handle_post
  make_response(HttpStatus::CREATED,
    {message: 'Resource created or updated'})
end

#Es la funcion que maneja que hacer cuando tenemos un request erroneo
def handle_bad_request
  make_response(HttpStatus::BAD_REQUEST,
    {message: 'Bad request (invalid input)'})
end

#Es la funcion que maneja que hacer cuando tratamos de realizar un metodo que no consideramos
#Parametro::
# method:: es el nombre del metodo que no debimos usar
def handle_bad_method(method)
  make_response(HttpStatus::METHOD_NOT_ALLOWED,
    {message: "Method not supported: #{method}"})
end

#Es el que se encarga de manejar el lambda
def lambda_handler(event:, context:)
  method = event.dig('requestContext', 'http', 'method')
  case method
  when 'GET'
    handle_get

  when 'POST'
    if store_score_item(event['body'])
      handle_post
    else
      handle_bad_request
    end

  else
    handle_bad_method(method)
  end
end