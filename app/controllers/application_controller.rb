class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'

  helper_method :current_user_admin?, :action_name_safe

  before_filter :set_p3p

  def set_p3p
    response.headers["P3P"]='CP="CAO PSA OUR"'
  end

  def current_user_admin?
    cookies[:loggedin].to_i == 1
  end
  
  def require_admin
    redirect_to "/"  unless current_user_admin?
  end

  def show_admin_nav
    @show_admin_nav = true
  end
  
  def action_name_safe
    # Eliminate any invalid iv characters from action.
    params[:action].gsub( /\W/, '' )
  end
  
end
