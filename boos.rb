require 'rubygems'
require 'sinatra'
require 'erb'

set :views, File.dirname(__FILE__) + '/templates'

before do
  @year = Time.now.year
end

get "/" do
  erb :index
end


