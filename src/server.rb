require 'sinatra'

#funct llamar lambda que se conecta a DYNAMO + PROCESOS get/post

get '/' do
    erb :main
end

get '/quiz/:n' do
    #funct llmara lambda
    @n = params['n'].to_i
    erb :quiz
end

get '/scores' do
    erb :scores
end