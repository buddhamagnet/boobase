require 'rubygems'
require 'sinatra'
require 'feedzirra'
require 'erb'

configure do
  set :views, File.dirname(__FILE__) + '/templates'
  set :default_url, 'http://audioboo.fm/tag/boobase'
  set :tag_url, 'http://audioboo.fm/tag/'
  set :notfound_url, 'http://audioboo.fm/tag/booboo'
  set :year, Time.now.year
  set :version, '2.2.0'
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
  @feed = get_feed(options.default_url)
  erb :index
end

get "/tag/:tag" do
  @feed = prep_feed(params[:tag])
  erb :feed
end

post "/" do
  @feed = prep_feed(params[:tag])
  erb :feed
end

helpers do
  
    def prep_feed(tag)
      feed = get_feed(options.tag_url + tag)
      if feed.empty?
        params[:tag] = 'boonotfound'
        feed = get_feed(options.notfound_url)
      end
      feed
    end
    
    def get_feed(feed)
      geotagged_boos = []
      Feedzirra::Feed.add_common_feed_entry_element("georss:point", :as => :location)
      feed = Feedzirra::Feed.fetch_and_parse(feed + '.rss')
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



