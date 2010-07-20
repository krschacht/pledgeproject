class AdminController < ApplicationController

  before_filter :require_user, :show_admin_nav

  def index
  end
  
  def setup
  end

end
