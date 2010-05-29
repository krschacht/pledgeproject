class AdminController < ApplicationController

  def projects
    @projects = Project.all
  end


end
