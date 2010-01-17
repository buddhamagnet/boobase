require 'rubygems'
require 'sinatra'
require 'erb'

set :views, File.dirname(__FILE__) + '/templates'

configure :production do
  set :title, 'boobase'
  set :api_key, 'ABQIAAAA2VaAko7JciZpUriPsbz9vxSBKIDUMqBSdWuz6-uVhYP5NoAnMRSiBpF9QkcfjG5N5LEc3b483p5igA'
end

configure :test do
  set :title, 'boostage'
  set :api_key, 'ABQIAAAA2VaAko7JciZpUriPsbz9vxRPbVWv-urirlRr1aZdrBxQATLMMxRdGUaA96cxmpl6IYSp25QzK57VRw'
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


