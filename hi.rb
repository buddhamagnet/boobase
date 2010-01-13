require 'rubygems'
require 'sinatra'
require 'erb'

set :views, File.dirname(__FILE__) + '/templates'

before do
  @time = Time.now
end

get '/' do
  erb :index
end


