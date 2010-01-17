require 'rubygems'
require 'sinatra'
require 'erb'

set :views, File.dirname(__FILE__) + '/templates'

configure :production do
  set :title, 'boobase'
end

configure :test do
  set :title, 'boostage'
end

configure :development do
  set :title, 'boodev'
end

before do
  @year = Time.now.year
  @title = options.title
end

get "/" do
  erb :index
end


