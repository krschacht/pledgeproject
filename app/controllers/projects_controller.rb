class ProjectsController < ApplicationController

  def widget
    @user = User.find( params[:id] )
    @projects = @user.projects

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @projects }
      format.js {render :content_type => 'text/javascript'}
    end

  end
  
end
