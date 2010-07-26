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
    @body_text.gsub!( /@PLEDGE_AMOUNTS@/, @pledges.collect { |p| p.amount }.map { |i| "$#{i}" }.to_sentence )
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

end
