class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  helper_method :current_user_session, :current_user,
                :current_user_admin?, :action_name_safe

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
  
private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

end
