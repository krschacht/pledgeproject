class AdminController < ApplicationController

  before_filter :require_user, :show_admin_nav

  def index
    @projects   = current_user.projects
    @groups     = current_user.groups
  end
  
  def setup
  end

end
