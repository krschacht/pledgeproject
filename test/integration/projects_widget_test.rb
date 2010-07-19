require 'test_helper'

class ProjectsWidgetTest < ActionController::IntegrationTest
  fixtures :all

  test "make sure widget can be served" do
    id = users(:ari).id
    
    get "/users/#{id}/projects/widget"
    assert :success
    assert_template 'widget'

    get "/users/#{id}/projects/widget.js"
    assert :success
    assert_template 'widget'
  end
  
end
