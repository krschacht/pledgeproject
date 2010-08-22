class VotesController < ApplicationController

  protect_from_forgery :except => [:create]
  before_filter :set_group

  def new_embed
    @vote = Vote.new
    @group.projects.length.times { @vote.pledges.build }
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vote }
    end
  end

  def new
    @vote = Vote.new
    @group.projects.length.times { @vote.pledges.build }
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vote }
    end
  end

  def create
    # Pledges have identical fields (name, email, etc). We only
    # showed these fields for the first project so now we need
    # to copy those values to all the other pledges before saving.
    
    vote_params = params[:vote]
    vote_params["pledges_attributes"].keys.each do |i|
      if ( i != "0" )
        vote_params["pledges_attributes"][i] =
          vote_params["pledges_attributes"]["0"].merge(
            vote_params["pledges_attributes"][i]
          )
      end
    end

    @vote = Vote.new(vote_params)

    respond_to do |format|
      if @vote.save
        Delayed::Job.enqueue EmailJob.new(:project_notifier, :pledge_received, @vote )        
        Delayed::Job.enqueue EmailJob.new(:pledger_notifier, :pledge_received, @vote )
        
        format.html do

          if @group.vote_done_url.to_s.empty?
            logger.info("using redirect_to #{done_vote_path( :group_id => @group, :id => @vote )}")
            redirect_to( done_vote_path( :group_id => @group, :id => @vote ) )
          else
            logger.info("using javascript #{@group.vote_done_url}")
            render :text => "<html><body><script type='text/javascript'>" +
                            "parent.location.href = '#{@group.vote_done_url}';" +
                            "</script></body></html>"
          end
        end
        format.xml  { render :xml => @vote, :status => :created, :location => @vote }
      else
        format.html { render :action => params[:return_action] }
        format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
      end
    end
    
  end

  def done
  end

private

  def set_group
    @group = Group.find( params[:group_id] )
  end
  
end
