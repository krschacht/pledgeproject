require 'test_helper'

class ProjectsWidgetTest < ActionController::IntegrationTest
  fixtures :all

  test "make sure widget can be served" do
    get "/projects/widget"
    assert :success
    assert_template 'widget'

    get "/projects/widget.js"
    assert :success
    assert_template 'widget'
  end
end
