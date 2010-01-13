require 'rubygems'
require 'sinatra'
require 'erb'

set :views, File.dirname(__FILE__) + '/templates'

get '/' do
  erb :index
end

get '/say/*/to/*' do
  'Hey ' + params['splat'][0] + ' I say ' + params['splat'][1]
end

