require 'json'
require 'aws-sdk-dynamodb'

#Constant that contains the dynamo client instance
DYNAMODB = Aws::DynamoDB::Client.new
#Constant that contains the name of the table that will be used
TABLE_NAME = 'scores'

# The +HttpStatus+ class represents the posible HTTP status codes
# to return in the response
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

def make_response(code, body)
  {
    statusCode: code,
    headers: {
      "Content-Type" => "application/json; charset=utf-8"
    },
    body: JSON.generate(body)
  }
end

def make_result_list(items)
  items.map do |item| {
      'nombre' => item['Username'],
      'score' => item['Right'].to_i
    }
  end
end


def sort_items(items)
  items.sort! {|a, b| a['score'] <=> b['score']}
end


def get_scores
  items = DYNAMODB.scan(table_name: TABLE_NAME).items
  sort_items(items)
  make_result_list(items)
end


def parse_body(body)
  if body
    begin
      data = JSON.parse(body)
      data.key?('Username') and data.key?('timestamp') ? data : nil
    rescue JSON::ParserError
      nil
    end
  else
    nil
  end
end


def store_score_item(body)
  data = parse_body(body)
  if data
    DYNAMODB.put_item(table_name: TABLE_NAME, item: data)
    true
  else
    false
  end
end


def handle_get
  make_response(HttpStatus::OK, get_scores)
end


def handle_post
  make_response(HttpStatus::CREATED,
    {message: 'Resource created or updated'})
end


def handle_bad_request
  make_response(HttpStatus::BAD_REQUEST,
    {message: 'Bad request (invalid input)'})
end


def handle_bad_method(method)
  make_response(HttpStatus::METHOD_NOT_ALLOWED,
    {message: "Method not supported: #{method}"})
end


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