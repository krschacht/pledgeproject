module PledgesHelper

  def return_action_name
    params[:return_action] || action_name_safe
  end
  
end
