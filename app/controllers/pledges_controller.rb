class PledgesController < ApplicationController

  protect_from_forgery :except => [:create]
  before_filter :set_project

  def new_embed
    @pledge = Pledge.new
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @pledge }
      format.js { render :content_type => 'text/javascript'}
    end
  end
  
  def new
    @pledge = Pledge.new
    
    @page_title = @project.title
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pledge }
      # format.js {render :content_type => 'text/javascript'}
    end
  end

  def create
    @pledge = Pledge.new( params[:pledge] )
    
    respond_to do |format|
      if @pledge.save
        ProjectNotifier.pledge_received( @pledge ).deliver
        PledgerNotifier.pledge_received( @pledge ).deliver
        
        format.html do

          if @project.pledge_done_url.to_s.empty?
            logger.info("using redirect_to #{done_pledge_path( :project_id => @project, :id => @pledge )}")
            redirect_to( done_pledge_path( :project_id => @project, :id => @pledge ) )
          else
            logger.info("using javascript #{@project.pledge_done_url}")
            render :text => "<html><body><script type='text/javascript'>" +
                            "parent.location.href = '#{@project.pledge_done_url}';" +
                            "</script></body></html>"
          end
        end
        format.xml  { render :xml => @pledge, :status => :created, :location => @pledge }
      else
        format.html { render :action => params[:return_action] }
        format.xml  { render :xml => @pledge.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def done
  end
  
private

  def set_project
    @project = Project.find( params[:project_id] )  if params[:project_id]
  end


end
