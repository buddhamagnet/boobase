require 'rubygems'
require 'sinatra'
require 'feedzirra'
require 'nokogiri'
require 'erb'
require 'uri'
require 'open-uri'

module Sinatra::Partials
  def partial(template, *args)
    template_array = template.to_s.split('/')
    template = template_array[0..-2].join('/') + "/_#{template_array[-1]}"
    options = args.last.is_a?(Hash) ? args.pop : {}
    options.merge!(:layout => false)
    if collection = options.delete(:collection) then
      collection.inject([]) do |buffer, member|
        buffer << erb(:"#{template}", options.merge(:layout =>
        false, :locals => {template_array[-1].to_sym => member}))
      end.join("\n")
    else
      erb(:"#{template}", options)
    end
  end
end

include Sinatra::Partials

configure do
  set :views, File.dirname(__FILE__) + '/templates'
  set :audioboo_url, 'http://audioboo.fm.'
  set :recent_url, 'http://audioboo.fm/boos.atom'
  set :featured_url, 'http://audioboo.fm/boos/featured.atom'
  set :popular_url, 'http://audioboo.fm/boos/popular.atom'
  set :tag_url, 'http://audioboo.fm/tag/'
  set :default_url, 'http://audioboo.fm/tag/boobase.atom'
  set :notfound_url, 'http://audioboo.fm/tag/booboo.atom'
  set :user_url, 'http://audioboo.fm/users/'
  set :api_get_userid, 'http://api.audioboo.fm/users.xml?find[username]='
  set :year, Time.now.year
  set :version, '2.5.0'
end

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
  set :api_key, FALSE
end

before do
  @year = options.year
  @title = options.title
  @api_key = options.api_key
  @version = options.version
end

not_found do
  erb :index
end

get "/" do
  @feed = prep_feed(options.default_url)
  erb :index
end

get "/recent" do
  @feed = prep_feed(options.recent_url)
  erb :index
end 

get "/featured" do
  @feed = prep_feed(options.featured_url)
  erb :index
end

get "/popular" do
  @feed = prep_feed(options.popular_url)
  erb :index
end

get "/:tag" do
  @feed = prep_feed(options.tag_url + URI.escape(params[:tag]) + '.atom')
  erb :index
end

get "/bigscreen/:tag" do
  @feed = prep_feed(options.tag_url + URI.escape(params[:tag]) + '.atom')
  @fullscreen = TRUE
  erb :index
end

get "/user/:user" do
  @feed = prep_feed(options.user_url + get_user(params[:user]) + '/boos.atom')
  params[:tag] = params[:user]
  erb :index
end

post "/user" do
  @feed = prep_feed(options.user_url + get_user(params[:user]) + '/boos.atom')
  params[:tag] = params[:user]
  erb :index
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



