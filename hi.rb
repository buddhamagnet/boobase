require 'rubygems'
require 'sinatra'
require 'erb'

set :views, File.dirname(__FILE__) + '/templates'

get '/' do
  erb :index
end

get '/shorten' do
  params.inspect
end

