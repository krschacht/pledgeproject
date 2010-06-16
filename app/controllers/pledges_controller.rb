class PledgesController < ApplicationController

  # GET /pledges/new
  # GET /pledges/new.xml
  def new_embed
    @pledge = Pledge.new
    @project = Project.find( params[:project_id].to_i )
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pledge }
      format.js {render :content_type => 'text/javascript'}
    end
  end
  
  def new
    @pledge = Pledge.new
    @project = Project.find( params[:project_id].to_i )
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pledge }
      # format.js {render :content_type => 'text/javascript'}
    end
  end

  # POST /pledges
  # POST /pledges.xml
  def create
    @pledge = Pledge.new(params[:pledge])
    @project = Project.find( params[:project_id].to_i )
    
    respond_to do |format|
      if @pledge.save
        format.html { redirect_to(admin_pledge_url(@pledge), :notice => 'Pledge was successfully created.') }
        format.xml  { render :xml => @pledge, :status => :created, :location => @pledge }
      else
        format.html { render :action => params[:prev_action] }
        format.xml  { render :xml => @pledge.errors, :status => :unprocessable_entity }
      end
    end
  end

end
