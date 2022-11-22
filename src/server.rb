require 'sinatra'

get '/' do
    erb :main
end

get '/quiz/:n' do
    @n = params['n'].to_i
    erb :quiz
end