require 'test_helper'

class MakingAPledgeTest < ActionController::IntegrationTest
  fixtures :all

  test "making a pledge" do
    project_id = projects(:letter).id
    get "/projects/#{project_id}/pledges/new"
    assert :success
    
    assert_select 'h2', /Letter to the Editor/
    assert_select 'input[type=hidden][name=return_action][value=new]'

    post_via_redirect '/pledges',  :return_action => 'new', 
                      :pledge => { 
                        :project_id   => project_id,
                        :first_name   => 'Pete',
                        :last_name    => 'Smith',
                        :email        => 'pete@smith.com',
                        :subscribe_me => 1,
                        :amount       => 20,
                        :note         => "I like this project!" }
    assert_response :success
    assert_template :done
    
    assert_select 'div', /has been saved/
  end

  test "error making a pledge, then successful" do
    project_id = projects(:letter).id
    get "/projects/#{project_id}/pledges/new"
    assert :success

    post '/pledges', :return_action => 'new', :pledge => { :project_id => project_id }
    assert_response :success

    assert_select 'h2', /5 errors/
  end
end
