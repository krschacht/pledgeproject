class AdminController < ApplicationController

  before_filter :require_user, :show_admin_nav
  before_filter :require_super_admin, :only => [ :su ]

  def index
    @projects   = current_user.projects
    @groups     = current_user.groups
  end
  
  def setup
  end
  
  def su
    user = User.find( params[:id] )
    session[:su_user] = current_user.id
    current_user_session.destroy
    UserSession.create!( user )
    flash[:notice] = "You've been logged in as #{user.full_name}"
    
    redirect_to admin_path
  end

  def unsu
    if session[:su_user]
      user = User.find( session[:su_user] )
      current_user_session.destroy
      UserSession.create!( user )
      session.delete :su_user
      
      flash[:notice] = "You've been logged in as #{user.full_name}"
    end
    
    redirect_to admin_path
  end
  
end
