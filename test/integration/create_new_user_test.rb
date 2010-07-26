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
    assert_select 'h2', /13 errors/    
    user_attrib = {
      :email                  => 'diana@gmail.com',
      :password               => 'test',
      :first_name             => 'Diana',
      :last_name              => 'Hsieh',
      :site_name              => 'NoodleFood',
      :from_email             => 'diana@dianahsieh.com',
      :pledge_confirmation_subject => "You've made a pledge!",
      :pledge_confirmation_body => <<-END
Hi @PLEDGE_FIRST_NAME@,

I've received your pledge(s) of @PLEDGE_AMOUNTS@ for the project(s) @PLEDGE_PROJECT_TITLES@. Thank you so much for your support!

I'll post updates about the project(s) to @SITE_NAME@, and I'll e-mail you any important news too. Remember, you don't owe any money until a project receives enough money to get started. If and when that happens, I'll e-mail you an invoice.

If you have any questions, you can e-mail me by replying to this message.

Thanks again for your support!

@USER_FULL_NAME@
END
    }
    post_via_redirect '/account', :user => user_attrib.merge( { :password_confirmation => 'abcd' })
    assert_response :success
    assert_select 'ul', /password doesn't match/i    
    post_via_redirect '/account', :user => user_attrib.merge( { :password_confirmation => 'test' })
    assert_response :success
    assert_select 'body', /account registered/i
    assert_select 'body', /create new project/i

  # end
  # 
  # test "login user" do
  #   
  #   # try to access admin, make sure it prompts for login
  #   get "/admin"
  #   assert_redirected_to '/user_session/new'
  #   get '/user_session/new'
  #   assert_select 'h1', /Login/
  #   
  #   # login
  #   post_via_redirect '/user_session', :user_session => { :email => 'diana@gmail.com', :password => 'test', :remember_me => 0 }
  #   assert_response :success
  #   assert_select 'body', /login successful/i
    
    # Now that you're logged in, first test editing your account
    get '/account/edit'
    assert_response :success
    assert_select 'h1', /edit my account/i
    user_attrib.delete(:password)
    user_attrib.delete(:site_name)
    put_via_redirect '/account', :user => user_attrib.merge( :site_name => 'Super-NoodleFood' )
    assert_response :success
    assert_equal 'Account updated.', flash[:notice]

    # Create a new project (actually 2 of them, we're going to delete one)
    project_titleA = 'Super Test project'
    get '/admin/projects/new'
    post_via_redirect '/admin/projects', :project => { :title => project_titleA }
    post_via_redirect '/admin/projects', :project => { :title => project_titleA + '2' }
    assert_response :success
    assert_equal 'Project was successfully created.', flash[:notice]
    project = Project.find_by_title( project_titleA )
    project2 = Project.find_by_title( project_titleA + '2' )

    # Make sure project shows up
    get '/admin/projects'
    assert_select 'body', /#{project_titleA}/
    assert_select 'body', /#{project_titleA + '2'}/
    
    # Make sure all the links on this page work
    get "/admin/projects/#{project.id}/edit"
    assert_select 'h1', /Editing project/
    get "/admin/projects/#{project.id}/pledges"
    assert_select 'body', /download comma delimited/i
    get "/admin/projects/#{project.id}/pledge_embed"
    assert_select 'body', /copy and paste/i
    get "/projects/#{project.id}/pledges/new_embed"
    assert_select 'h2', /Pledge for #{project_titleA}/
    assert_select 'div.form_pretty_wrapper', false
    get "/projects/#{project.id}/pledges/new"
    assert_select 'h2', /Pledge for #{project_titleA}/
    assert_select 'div.form_pretty_wrapper'
    
    # Make sure a project can be deleted
    delete_via_redirect "admin/projects/#{project2.id}"
    assert_response :success
    assert_equal 'Project was deleted.', flash[:notice]
    get '/admin/projects'
    assert_select 'div.title a', {:count => 1, :text => project_titleA }
    assert_select 'div.title a', {:count => 0, :text => project_titleA + '2' }
    
    # Submit some pledges
    post_via_redirect "/projects/#{project.id}/pledges", 
      :pledge => {  :first_name     => 'Keith',
                    :last_name      => 'Schacht',
                    :email          => 'krschacht@gmail.com',
                    :subscribe_me   => 1,
                    :amount         => 50,
                    :note           => 'This is a question',
                    :project_id     => project.id }
    assert_response :success
    assert_select 'div.done_msg', /Your pledge has been saved./

    post_via_redirect "/projects/#{project.id}/pledges", 
      :pledge => {  :first_name     => 'Pari',
                    :last_name      => 'Schacht',
                    :email          => 'pari@nurturingwisdom.com',
                    :subscribe_me   => 0,
                    :amount         => 60,
                    :note           => 'A second question',
                    :project_id     => project.id }
    assert_response :success

    post_via_redirect "/projects/#{project.id}/pledges", 
      :pledge => {  :first_name     => 'Ari',
                    :last_name      => 'Armstrong',
                    :email          => 'ari@armstrong.com',
                    :subscribe_me   => 1,
                    :amount         => 25,
                    :note           => 'This is a third question',
                    :project_id     => project.id }
    assert_response :success
    
    ## TODO: Test failed pledges
    
    # Check that pledges were properly recorded
    get '/admin/projects'
    assert_select 'div.project div.title a', 1
    assert_select 'div.project', /3 pledges/
    assert_select 'div.project', /\$135\./    
    
    get "/admin/projects/#{project.id}/pledges"
    assert_select 'table tr', 4 # 2 projects, 1 row is header row
    assert_select 'table tr.paid_false', 3
    assert_select 'table tr.paid_true', 0
    pledge = project.pledges.first

    # Mark a pledge as paid then unpaid
    put_via_redirect "/admin/projects/#{project.id}/pledges/#{pledge.id}", 
      :pledge => {  :paid => true }
    assert_response :success
    get "/admin/projects/#{project.id}/pledges"
    assert_select 'table tr.paid_false', 2
    assert_select 'table tr.paid_true', 1   

    put_via_redirect "/admin/projects/#{project.id}/pledges/#{pledge.id}", 
      :pledge => {  :paid => false }
    assert_response :success
    get "/admin/projects/#{project.id}/pledges"
    assert_select 'table tr.paid_false', 3
    assert_select 'table tr.paid_true', 0

    # Edit a pledge
    get "/admin/projects/#{project.id}/pledges/#{pledge.id}/edit"
    assert_response :success
    assert_select 'h1', /Editing/
    attributes = pledge.attributes
    attributes.delete("created_on")
    attributes.delete("updated_on")
    attributes.delete("id")
    attributes.delete("amount")
    
    put_via_redirect "/admin/projects/#{project.id}/pledges/#{pledge.id}", 
      :pledge => attributes.merge( { :amount => 999 } )      
    assert_response :success
    get "/admin/projects/#{project.id}/pledges"
    assert_select 'td', /999/
    
    # Delete a pledge (should be 2 remaining after this)
    delete_via_redirect "/admin/projects/#{project.id}/pledges/#{pledge.id}"
    assert_response :success
    assert_equal 'Pledge was deleted.', flash[:notice]
    get "/admin/projects/#{project.id}/pledges"
    assert_select 'table tr', 3  # 2 projects, 1 row is header row
    
    # Test download CSV links
    get "/admin/projects/#{project.id}/pledges.csv"
    assert_response :success
    get "/admin/projects/#{project.id}/pledges.csv?delimiter=tab"
    assert_response :success
    
    ####### Test the Multi-Pledge Forms ############
    
    # Create a second project so we can use it on the form
    project_titleB = 'New Podcast'
    post_via_redirect '/admin/projects', :project => { :title => project_titleB }
    projectB = Project.find_by_title( project_titleB )
        
    get '/admin'
    assert_select 'body', /create new pledge form/i
    get 'admin/groups/new'
    assert_select 'h1', /new pledge form/i
    
    ###### end pledge forms #########
    
    # Logout
    delete_via_redirect '/user_session'
    assert_response :success
    assert_equal 'Logout successful!', flash[:notice]
    
  end

  private
  
    module CustomDsl
      def login
      end
    end
    
end