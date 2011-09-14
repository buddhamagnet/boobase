require 'rubygems'
require 'sinatra'
require 'feedzirra'
require 'nokogiri'
require 'erb'
require 'sass'
require 'uri'
require 'open-uri'

configure do
  set :views, File.dirname(__FILE__) + '/templates'
  set :audioboo_url, 'http://audioboo.fm.'
  set :magic_url, 'http://audioboo.fm/users/229/tags/78-boobase.atom'
  set :recent_url, 'http://audioboo.fm/boos.atom'
  set :featured_url, 'http://audioboo.fm/boos/featured.atom'
  set :popular_url, 'http://audioboo.fm/boos/popular.atom'
  set :tag_url, 'http://audioboo.fm/tag/'
  set :notfound_url, 'http://audioboo.fm/tag/booboo.atom'
  set :user_url, 'http://audioboo.fm/users/'
  set :api_get_userid, 'http://api.audioboo.fm/users.xml?find[username]='
  set :year, Time.now.year
  set :version, '2.7.0'
end

configure :production do
  set :title, 'boobase'
  set :api_key, 'ABQIAAAA2VaAko7JciZpUriPsbz9vxRDvOLbrWiHJ3CicabozJttxm0fcRSHTAN9PKMpSmb-x2_M7kgXsE2-3w'
  set :environment, 'production'
end

configure :test do
  set :title, 'boostage'
  set :api_key, 'ABQIAAAA2VaAko7JciZpUriPsbz9vxRPbVWv-urirlRr1aZdrBxQATLMMxRdGUaA96cxmpl6IYSp25QzK57VRw'
  set :environment, 'staging'
end

configure :development do
  set :title, 'boodev'
  set :api_key, FALSE
  set :environment, 'development'
end

before do
  @year = options.year
  @title = options.title
  @api_key = options.api_key
  @version = options.version
  @env = options.environment
end

not_found do
  erb :index
end

get '/css/sassed.css' do
  content_type 'text/css', :charset => 'utf_8'
  sass :sassed
end

get "/" do
  @feed = prep_feed(options.magic_url)
  @mode = 'index'
  erb :index
end

get "/recent" do
  @feed = prep_feed(options.recent_url)
  @mode = 'recent'
  erb :index
end 

get "/featured" do
  @feed = prep_feed(options.featured_url)
  @mode = 'featured'
  erb :index
end

get "/popular" do
  @feed = prep_feed(options.popular_url)
  @mode = 'popular'
  erb :index
end

get "/:tag" do
  @feed = prep_feed(options.tag_url + URI.escape(params[:tag]) + '.atom')
  @mode = 'tag'
  erb :index
end

get "/bigscreen/:tag" do
  @feed = prep_feed(options.tag_url + URI.escape(params[:tag]) + '.atom')
  @mode = 'tag'
  @fullscreen = TRUE
  erb :index
end

get "/user/:user" do
  @feed = prep_feed(options.user_url + get_user(params[:user]) + '/boos.atom')
  params[:tag] = params[:user]
  @mode = 'user'
  erb :index
end

post "/user" do
  @feed = prep_feed(options.user_url + get_user(params[:user]) + '/boos.atom')
  @mode = 'user'
  params[:tag] = params[:user]
  erb :index
end

post "/zoom" do
  @longitude = params[:longitude]
  @latitude = params[:latitude]
  @title = params[:title]
  @author = params[:author]
  @published = params[:published]
  @url = params[:url]
  @mode = 'zoom'
  erb :zoom, :layout => false
end

post "/" do
  @feed = prep_feed(options.tag_url + URI.escape(params[:tag]) + '.atom')
  erb :index
end

helpers do
  
    def prep_feed(url)
      feed = get_feed(url)
      if feed.empty?
        params[:tag] = 'boonotfound'
        feed = get_feed(options.notfound_url)
      end
      params[:embed_url] = url
      feed
    end
    
    def get_feed(url)
      geotagged_boos = []
      elements = {'georss:point' => :location, 'itunes:keywords' => :tags}
      elements.each do |key, value|
        Feedzirra::Feed.add_common_feed_entry_element(key, :as => value)
      end
      feed = Feedzirra::Feed.fetch_and_parse(url)
      unless feed.entries.empty?
        for item in feed.entries
          unless !item.location
            geotagged_boos << item
          end
        end
      end
      geotagged_boos
    end
    
    def get_user(user)
      userid = Nokogiri::XML(open(options.api_get_userid + user)).xpath('//id').text
    end
  
end



