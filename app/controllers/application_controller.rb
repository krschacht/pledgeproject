class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'

  helper_method :current_user_admin?


  def current_user_admin?
    return true
  end
  
  def require_admin
    redirect_to "/"  unless current_user_admin?
  end

end
