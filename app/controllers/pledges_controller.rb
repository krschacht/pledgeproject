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
    
    @page_title = @project.title
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pledge }
      # format.js {render :content_type => 'text/javascript'}
    end
  end

  # POST /pledges
  # POST /pledges.xml
  def create
    @pledge = Pledge.new( params[:pledge] )
    @project = Project.find( params[:pledge][:project_id] )
    
    respond_to do |format|
      if @pledge.save
        format.html { redirect_to(pledge_done_url(@project), :notice => 'Your pledge has been saved. Thanks!') }
        format.xml  { render :xml => @pledge, :status => :created, :location => @pledge }
      else
        format.html { render :action => params[:return_action] }
        format.xml  { render :xml => @pledge.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def done
    @project = Project.find( params[:id].to_i )   if params[:id]
    redirect_to( @project.pledge_done_url )       unless @project.pledge_done_url.nil? 
  end

end
