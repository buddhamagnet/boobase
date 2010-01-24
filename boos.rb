require 'rubygems'
require 'sinatra'
require 'feedzirra'
require 'erb'
require 'uri'

configure do
  set :views, File.dirname(__FILE__) + '/templates'
  set :audioboo_url, 'http://audioboo.fm.'
  set :recent_url, 'http://audioboo.fm/boos.atom'
  set :featured_url, 'http://audioboo.fm/boos/featured.atom'
  set :popular_url, 'http://audioboo.fm/boos/popular.atom'
  set :tag_url, 'http://audioboo.fm/tag/'
  set :default_url, 'http://audioboo.fm/tag/boobase.atom'
  set :notfound_url, 'http://audioboo.fm/tag/booboo.atom'
  set :year, Time.now.year
  set :version, '2.4.0'
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
      Feedzirra::Feed.add_common_feed_entry_element("georss:point", :as => :location)
      Feedzirra::Feed.add_common_feed_entry_element("itunes:keywords", :as => :tags)
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
  
end



