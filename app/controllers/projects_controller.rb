class ProjectsController < ApplicationController

  def widget
    @projects = Project.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @projects }
      format.js {render :content_type => 'text/javascript'}
    end

  end
  
end
