class AdminController < ApplicationController

  before_filter :require_admin, :only => [ :index ]

  def index
    @projects = Project.all
  end
  
  def projects
    @projects = Project.all
  end

  def login
    cookies.permanent[:loggedin] = 1  if params[:key]="dogpatch"
    
    redirect_to admin_url
  end
  
  def logout
    cookies.permanent[:loggedin] = 0    
    redirect_to admin_url
  end

end
