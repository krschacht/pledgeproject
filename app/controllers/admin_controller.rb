class AdminController < ApplicationController

  before_filter :require_user, :only => [ :index ]
  before_filter :show_admin_nav

  def index
    @projects = Project.all
  end

  # def login
  #   cookies.permanent[:loggedin] = 1  if params[:key]="dogpatch"
  #   
  #   redirect_to admin_url
  # end
  # 
  # def logout
  #   cookies.permanent[:loggedin] = 0    
  #   redirect_to admin_url
  # end

end
