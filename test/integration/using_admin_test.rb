require 'test_helper'

class UsingAdminTest < ActionController::IntegrationTest
  fixtures :all

  test "make sure widget can be served" do
    assert true
  end
  
  # make sure people can't alter the URL to view projects which are not theirs
  # make sure when creating projects they get attached to the correct person
  
end