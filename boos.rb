require 'rubygems'
require 'sinatra'
require 'erb'

set :views, File.dirname(__FILE__) + '/templates'

configure :production do
  set :title, 'boobase'
  set :api_key, 'ABQIAAAA2VaAko7JciZpUriPsbz9vxSiUcEld95qrkTs5z8_UvHFkFRNsRTXjDRbtcsTcZNhltcE7Jrr0aKJog'
end

configure :test do
  set :title, 'boostage'
  set :api_key, 'ABQIAAAA2VaAko7JciZpUriPsbz9vxSWBiZ5gmuB-Fi-87K_EhH1x73z6BRV0VBKo7BFKBRxR9UmNf-vTU-KzA'
end

configure :development do
  set :title, 'boodev'
end

before do
  @year = Time.now.year
  @title = options.title
  @api_key = options.api_key
end

get "/" do
  erb :index
end


