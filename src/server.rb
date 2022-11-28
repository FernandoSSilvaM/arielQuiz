require 'json'
require 'faraday'
require 'sinatra'
require 'aws-sdk-dynamodb'

lambdascore = "https://ec26j6i46tsug6hze2eb5jyqui0uhcbe.lambda-url.us-east-1.on.aws/src/models"

get '/' do
    erb :main
end

get '/quiz/:n' do
    #funct llmara lambda
    @n = params['n'].to_i
    erb :quiz
end

get '/scores' do
    connection = Faraday.new(url:lambdascore)
    response = connection.get
    @scores = []

    if response.success?
      @scores = JSON.parse(response.body)
    end
    puts @scores
    erb :scores
end

post '/scores' do
      dynamodb = Aws::DynamoDB::Client.new

      new_item = {
        nombre: session[:nombre],
        score: session[:score].to_i
      }

    dynamodb.put_item(table_name: 'scores', item: new_item)
    redirect '/scores'
end