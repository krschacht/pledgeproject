require 'test_helper'

class CreateNewUserTest < ActionController::IntegrationTest
  fixtures :all

  test "register a new user" do

    # try to access admin, make sure it prompts for login
    get "/admin"
    assert_redirected_to '/user_session/new'
    get '/user_session/new'
    assert_select 'h1', /Login/

    # make sure it errors out when trying to login w/ nothing
    post '/user_session'
    assert_response :success
    assert_select 'h2', /error/
    assert_select 'h3', /register/
    
    # make sure accounts can be properly registered
    get '/account/new'
    post_via_redirect '/account', :user => { :password_confirmation => ' ' }
    assert_response :success
    assert_select 'h2', /7 errors/    
    user = {
      :email                  => 'diana@gmail.com',
      :password               => 'test',
      :first_name             => 'Diana',
      :last_name              => 'Hsieh',
      :from_email             => 'diana@dianahsieh.com',
      :pledge_confirmation_subject => "You've made a pledge!",
      :pledge_confirmation_body => <<-END
Hi @PLEDGE_FIRST_NAME@,

I've received your pledge of $@PLEDGE_AMOUNT@ for the project '@PLEDGE_PROJECT_TITLE@'. Thank you so much for your support of this work!

I'll post updates about this project to @SITE_NAME@, and I'll e-mail you any important news too.  Remember, you don't owe any money until the project is completed.  If and when that happens, I'll e-mail you an invoice.

If you have any questions, you can e-mail me by replying to this message.

Thanks again for your support!

@USER_FULL_NAME@
END
    }
    post_via_redirect '/account', :user => user.merge( { :password_confirmation => 'abcd' })
    assert_response :success
    assert_select 'ul', /password doesn't match/i    
    post_via_redirect '/account', :user => user.merge( { :password_confirmation => 'test' })
    assert_response :success
    assert_select 'body', /account registered/i
    assert_select 'body', /create new project/i

    # Create a new project (actually 2 of them, we're going to delete one)
    project_title = 'Super Test project'
    get '/admin/projects/new'
    post_via_redirect '/admin/projects', :project => { :title => project_title }
    post_via_redirect '/admin/projects', :project => { :title => project_title + '2' }
    assert_response :success
    assert_select 'body', /project was successfully created/i
    project = Project.find_by_title( project_title )

    # Make sure project shows up
    get '/admin/projects'
    assert_select 'body', /#{project_title}/
    assert_select 'body', /#{project_title + '2'}/
    
    # Make sure all the links on this page work
    get "/admin/projects/#{project.id}/edit"
    assert_select 'h1', /Editing project/
    get "/admin/projects/#{project.id}/pledges"
    assert_select 'body', /download comma delimited/i
    get "/admin/projects/#{project.id}/pledge_embed"
    assert_select 'body', /copy and paste/i
    get "/projects/#{project.id}/pledges/new"
    assert_select 'h2', /Pledge for #{project_title}/
    
  end


  # test "making a pledge" do
  #    project_id = projects(:letter).id
  #    get "/projects/#{project_id}/pledges/new"
  #    assert :success
  # 
  #    assert_select 'h2', /Letter to the Editor/
  #    assert_select 'input[type=hidden][name=return_action][value=new]'
  # 
  #    post_via_redirect "/projects/#{project_id}/pledges",  :return_action => 'new', 
  #                      :pledge => { 
  #                        :project_id   => project_id,
  #                        :first_name   => 'Pete',
  #                        :last_name    => 'Smith',
  #                        :email        => 'pete@smith.com',
  #                        :subscribe_me => 1,
  #                        :amount       => 20,
  #                        :note         => "I like this project!" }
  #    assert_response :success
  #    assert_template :done
  # 
  #    assert_select 'div', /has been saved/
  #  end
  # 
  #  test "error making a pledge, then successful" do
  #    project_id = projects(:letter).id
  #    get "/projects/#{project_id}/pledges/new"
  #    assert :success
  # 
  #    post "/projects/#{project_id}/pledges", :return_action => 'new', :pledge => { :project_id => project_id }
  #    assert_response :success
  # 
  #    assert_select 'h2', /5 errors/
  #  end
  # 
  # make sure people can't alter the URL to view projects which are not theirs
  # make sure when creating projects they get attached to the correct person
  
end