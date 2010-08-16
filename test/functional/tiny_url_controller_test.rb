require 'test_helper'

class TinyUrlControllerTest < ActionController::TestCase

  test "should not forward" do
    get 'index', :id => "#{ tiny_urls(:amazon).id }-#{ tiny_urls(:amazon).key }xx"
    assert_redirected_to '/'
  end

  test "should forward" do
    get 'index', :id => "#{ tiny_urls(:amazon).id }-#{ tiny_urls(:amazon).key }"
    assert_redirected_to tiny_urls(:amazon).url
  end

end
