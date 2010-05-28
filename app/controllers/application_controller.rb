class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'


  def require_admin
    redirect_to "/"  unless true
  end

end
