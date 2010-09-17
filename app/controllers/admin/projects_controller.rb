class Admin::ProjectsController < ApplicationController

  before_filter :require_user, :show_admin_nav
  
  def index
    @projects   = current_user.projects
    @groups     = current_user.groups
  end

  def show
    @project = current_user.projects.find( params[:id] )
  end

  def new
    @project = Project.new
  end

  def edit
    @project = current_user.projects.find( params[:id] )
  end

  def create
    params[:project][:user_id] = current_user.id
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to(admin_projects_url, :notice => 'Project was successfully created.') }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @project = current_user.projects.find( params[:id] )

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to(admin_projects_url, :notice => 'Project was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project = current_user.projects.find( params[:id] )
    @project.destroy

    redirect_to( admin_projects_url, :notice => 'Project was deleted.' )
  end
  
  def pledge_embed
    @project = current_user.projects.find( params[:id] )
    
    @attrib = { :scrolling => 'no',
                :height => 710,
                :frameborder => 0,
                :style => 'width: 100%; border: 0px solid black;',
                :allowtransparency => 'true' }    
  end

  # def invoice
  #   project = Project.find( params[:id] )
  # 
  #   project.pledges.not_queued.each do |pledge|
  #     Delayed::Job.enqueue EmailJob.new(:pledger_notifier, :invoice, pledge )
  #   end
  #   
  #   redirect_to admin_project_pledges_path( project ), :notice => 'Invoices were sent.'
  # end

  def confirm_invoice
    @project = Project.find( params[:id] )

    @project_user = @project.user
    @body = @project_user.pledge_invoice_body    
  end
  
  def invoice_custom
    project = Project.find( params[:id] )

    body    = params[:body]
    subject = params[:subject]

    project.pledges.not_paid.each do |pledge|
      Delayed::Job.enqueue EmailJob.new(:pledger_notifier, :invoice_custom,
        { :pledge => pledge, :body => body, :subject => subject } )
      pledge.invoice_queued!
    end
    
    redirect_to admin_project_pledges_path( project ), :notice => 'Invoices were sent.'
  end
   
end
