require 'rubygems'
require 'sinatra'
require 'feedzirra'
require 'erb'

set :views, File.dirname(__FILE__) + '/templates'
set :default_url, 'http://audioboo.fm/tag/boobase'
set :tag_url, 'http://audioboo.fm/tag/'
set :notfound_url, 'http://audioboo.fm/tag/booboo'

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
  @version = '2.0.1'
end

not_found do
  erb :index
end

get "/" do
  @feed = get_feed(options.default_url)
  erb :index
end

get "/tag/:tag" do
  @feed = get_feed(options.tag_url + params[:tag])
  if !@feed
    params[:tag] = 'boobase'
    @feed = get_feed(options.notfound_url)
  end
  erb :feed
end

post "/tag" do
  @feed = get_feed(options.tag_url + params[:tag])
  if !@feed
    params[:tag] = 'boobase'
    @feed = get_feed(options.notfound_url)
  end  
  erb :feed
end

helpers do
    
    def get_feed(feed)
      geotagged_boos = []
      Feedzirra::Feed.add_common_feed_entry_element("georss:point", :as => :location)
        feed = Feedzirra::Feed.fetch_and_parse(feed + '.rss')
        if feed.entries.empty?
          return FALSE
        end
      for item in feed.entries
        unless !item.location
          geotagged_boos << item
        end
      end
      geotagged_boos
    end
  
end



