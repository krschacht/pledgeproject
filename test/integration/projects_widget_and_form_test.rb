require 'test_helper'

class ProjectsWidgetAndFormTest < ActionController::IntegrationTest
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
  
  test "make sure pledge forms can be served" do
    id = projects(:letter).id
    
    get "/projects/#{id}/pledges/new"
    assert :success
    assert_template 'new'

    get "/projects/#{id}/pledges/new_embed"
    assert :success
    assert_template 'new_embed'
  end
  
end
