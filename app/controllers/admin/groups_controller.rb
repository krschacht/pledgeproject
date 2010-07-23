class Admin::GroupsController < ApplicationController

  before_filter :require_user, :show_admin_nav
  before_filter :set_group, :except => [ :index, :new, :create ]

  def vote_embed
    @group = current_user.groups.find( params[:id] )
    
    @attrib = { :scrolling => 'no',
                :height => 655 + @group.projects.length * 65,
                :frameborder => 0,
                :style => 'width: 100%; border: 0px solid black;',
                :allowtransparency => 'true' }    
  end

  def index
    @groups = current_user.groups.all
  end

  def show
  end

  def new
    @group = Group.new
    @projects = current_user.projects
  end

  def edit
    @projects = current_user.projects
  end

  def create
    @projects = current_user.projects

    params[:group][:user_id] = current_user.id
    @group = Group.new(params[:group])

    respond_to do |groupat|
      if @group.save
        groupat.html { redirect_to(admin_path, :notice => 'Group was successfully created.') }
        groupat.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        groupat.html { render :action => "new" }
        groupat.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |groupat|
      if @group.update_attributes(params[:group])
        groupat.html { redirect_to(admin_path, :notice => 'Group was successfully updated.') }
        groupat.xml  { head :ok }
      else
        groupat.html { render :action => "edit" }
        groupat.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @group.destroy

    redirect_to( admin_url, :notice => 'Group was deleted.' )
  end
  
private

  def set_group
    @group = current_user.groups.find( params[:id] )
  end
  
end
