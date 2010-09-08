class Admin::PledgesController < ApplicationController

  before_filter :require_user, :show_admin_nav

  # GET /pledges
  # GET /pledges.xml
  def index
    # id = params[:id].gsub(/.*-/, '').to_i
    
    @project = Project.find( params[:project_id] )
    @pledges = @project.pledges
    @fields = [ :id, :first_name, :last_name, :email, :subscribe_me, :amount_pledged, :amount_paid, :internal_note, :note, :created_at ]

    delimiter_codes = {
      :tab    => "\t",
      :comma  => ","
    }

    respond_to do |format|
      format.html
      format.xml  { render :xml => @pledges }
      format.csv  do
        @delimeter = delimiter_codes[ (params[:delimiter] || :comma ).to_sym ]
        render :csv => @pledges
      end
    end
  end

  # GET /pledges/1
  # GET /pledges/1.xml
  def show
    @pledge = Pledge.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pledge }
    end
  end

  # GET /pledges/new
  # GET /pledges/new.xml
  def new
    @pledge = Pledge.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pledge }
    end
  end

  # GET /pledges/1/edit
  def edit
    @project = Project.find( params[:project_id] )
    @pledge = Pledge.find(params[:id])
  end

  # POST /pledges
  # POST /pledges.xml
  def create
    @pledge = Pledge.new(params[:pledge])

    respond_to do |format|
      if @pledge.save
        format.html { redirect_to(admin_pledge_url(@pledge), :notice => 'Pledge was successfully created.') }
        format.xml  { render :xml => @pledge, :status => :created, :location => @pledge }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pledge.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pledges/1
  # PUT /pledges/1.xml
  def update
    project = Project.find( params[:project_id] )
    @pledge = Pledge.find(params[:id])

    respond_to do |format|
      if @pledge.update_attributes(params[:pledge])
        format.html { redirect_to(admin_project_pledges_path( project ), :notice => 'Pledge was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pledge.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    project = Project.find( params[:project_id] )
    @pledge = Pledge.find( params[:id] )
    @pledge.destroy

    respond_to do |format|
      format.html { redirect_to( admin_project_pledges_path(project), :notice => 'Pledge was deleted.' ) }
      format.xml  { head :ok }
    end
  end
  
  # def invoice
  #   project = Project.find( params[:project_id] )
  #   pledge = project.pledges.find( params[:id] )
  #   
  #   unless pledge.invoice_queued?
  #     Delayed::Job.enqueue EmailJob.new(:pledger_notifier, :invoice, pledge )
  #     pledge.invoice_queued!
  #   end
  #   
  #   redirect_to admin_project_pledges_path( pledge.project ), :notice => 'Invoice was sent'    
  # end
  
  def confirm_invoice
    @project = Project.find( params[:project_id] )
    @pledge = @project.pledges.find( params[:id] )

    @project_user = @project.user
    @body = @project_user.pledge_invoice_body
    
    @body.gsub!( /@PLEDGE_FIRST_NAME@/, @pledge.first_name )
    @body.gsub!( /@PLEDGE_AMOUNT@/, '$' + @pledge.amount_pledged.to_f.to_s )
    @body.gsub!( /@PLEDGE_PROJECT_TITLE@/, @pledge.project.title )
    @body.gsub!( /@USER_FULL_NAME@/, @project_user.full_name )
  end
  
  def invoice_custom
    project = Project.find( params[:project_id] )
    pledge = project.pledges.find( params[:id] )

    body    = params[:body]
    subject = params[:subject]

    unless pledge.invoice_queued?
      Delayed::Job.enqueue EmailJob.new(:pledger_notifier, :invoice_custom, 
            { :pledge => pledge, :body => body, :subject => subject } )
      pledge.invoice_queued!
    end
    
    redirect_to admin_project_pledges_path( pledge.project ), :notice => 'Invoice was sent'    
  end
    
end
