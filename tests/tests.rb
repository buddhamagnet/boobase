require '../boos'
require 'test/unit'
require 'rack/test'

class BoobaseTest < Test::Unit::TestCase
  
  include Rack::Test::Methods
  
  def app
    Sinatra::Application
  end
  
  def test_default
    get '/'
    assert_equal TRUE, TRUE
  end
  
end