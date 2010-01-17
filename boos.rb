require 'rubygems'
require 'sinatra'
require 'feedzirra'
require 'erb'

set :views, File.dirname(__FILE__) + '/templates'
set :tag_url, 'http://audioboo.fm/tag/'

configure :production do
  set :title, 'boobase'
  set :api_key, 'ABQIAAAA2VaAko7JciZpUriPsbz9vxRDvOLbrWiHJ3CicabozJttxm0fcRSHTAN9PKMpSmb-x2_M7kgXsE2-3w'
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

get "/tag/:tag" do
  begin
    @feed = Feedzirra::Feed.fetch_and_parse(options.tag_url + params[:tag] + '.rss')
  rescue Error => e
    erb :fail
  end
  erb :feed
end


