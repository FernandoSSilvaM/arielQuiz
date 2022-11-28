# Final Project: Quiz Application with Microservices
# Date: 28-Nov-2022
# Authors:
#          A01746925 Fernando Sebastian Silva Miramontes
#          A01377205 Jose Luis Mata Lomelí

require 'json'
require 'faraday'
require 'sinatra'
require 'aws-sdk-dynamodb'

lambdascore = "https://ec26j6i46tsug6hze2eb5jyqui0uhcbe.lambda-url.us-east-1.on.aws/scores"

get '/' do
    erb :main
end

get '/quiz/:n' do
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