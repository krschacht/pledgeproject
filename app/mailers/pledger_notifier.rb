class PledgerNotifier < ActionMailer::Base

  def pledge_received( obj )
    
    if obj.is_a? Pledge
      
      @project_user = obj.project.user
      @pledge = obj
      @pledges = [ obj ]
      
    elsif obj.is_a? Vote

      @project_user = obj.group.project.user      
      @pledge = obj.pledge
      @pledges = obj.pledges
    else
      raise "Invalid object passed into notifier"
    end
    

    @body_text = @project_user.pledge_confirmation_body
    @body_text.gsub!( /@PLEDGE_FIRST_NAME@/, @pledge.first_name )
    @body_text.gsub!( /@PLEDGE_AMOUNTS@/, @pledges.collect { |p| p.amount_pledged }.map { |i| "$#{i}" }.to_sentence )
    @body_text.gsub!( /@PLEDGE_PROJECT_TITLES@/, @pledges.collect { |p| p.project.title }.map { |s| "'#{s}'" }.to_sentence )
    @body_text.gsub!( /@SITE_NAME@/, @project_user.site_name )
    @body_text.gsub!( /@USER_FULL_NAME@/, @project_user.full_name )

    mail  :from       => "#{ @project_user.full_name } <#{ @project_user.from_email }>",
          :sender     => @project_user.from_email,
          :reply_to   => @project_user.from_email,
          :reply_path => App.system_email,
          :to         => "#{ @pledge.full_name } <#{ @pledge.email }>", 
          :subject    => @project_user.pledge_confirmation_subject
  end

  def invoice_custom( params )
    @subject    = params[:subject]
    @body_text  = params[:body]
    @pledge     = params[:pledge]
    @pledge     = Pledge.find( @pledge )  unless @pledge.is_a? Pledge
    
    @project_user = @pledge.project.user    
    @invoice = PaypalPaymentRequest.new(
                  :business => @project_user.paypal_email,
                  :item_name => @pledge.project.title,
                  :amount => @pledge.amount_pledged.to_f,
                  :item_number => @pledge.id )

    @body_text.gsub!( /@INVOICE_URL@/, TinyUrl.for( @invoice.url ) )

    mail  :from       => "#{ @project_user.full_name } <#{ @project_user.from_email }>",
          :sender     => @project_user.from_email,
          :reply_to   => @project_user.from_email,
          :reply_path => App.system_email,
          :to         => "#{ @pledge.full_name } <#{ @pledge.email }>", 
          :subject    => @subject
  end
    
  def invoice( pledge )
    
    @pledge = pledge
    @project_user = pledge.project.user
    @invoice = PaypalPaymentRequest.new(
                  :business => @project_user.paypal_email,
                  :item_name => @pledge.project.title,
                  :amount => @pledge.amount_pledged.to_f,
                  :item_number => @pledge.id )
    
    @body_text = @project_user.pledge_invoice_body
    @body_text.gsub!( /@PLEDGE_FIRST_NAME@/, @pledge.first_name )
    @body_text.gsub!( /@PLEDGE_AMOUNT@/, '$' + @pledge.amount_pledged.to_f.to_s )
    @body_text.gsub!( /@PLEDGE_PROJECT_TITLE@/, @pledge.project.title )
    @body_text.gsub!( /@USER_FULL_NAME@/, @project_user.full_name )
    @body_text.gsub!( /@INVOICE_URL@/, TinyUrl.for( @invoice.url ) )

    mail  :from       => "#{ @project_user.full_name } <#{ @project_user.from_email }>",
          :sender     => @project_user.from_email,
          :reply_to   => @project_user.from_email,
          :reply_path => App.system_email,
          :to         => "#{ @pledge.full_name } <#{ @pledge.email }>", 
          :subject    => @project_user.pledge_invoice_subject
  end

end
