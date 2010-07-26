class ProjectNotifier < ActionMailer::Base

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.actionmailer.admin_notifier.pledge_received.subject
  #
  def pledge_received( obj )
    
    if obj.is_a? Pledge
      
      u = obj.project.user
      @title = obj.project.title
      @pledges = [ obj ]
      @pledge = obj
      
    elsif obj.is_a? Vote
      
      u = obj.group.project.user
      @title = obj.group.title
      @pledges = obj.pledges
      @pledge = obj.pledge      
    else
      raise "Invalid object passed into notifier"
    end

    mail  :from       => "#{@pledge.full_name} <#{@pledge.email}>",
          :sender     => @pledge.email,
          :reply_to   => @pledge.email,
          :reply_path => App.system_email,
          :to         => u.email, 
          :subject => "Pledge Received - #{ @pledge.full_name } - #{ @title }"
  end
end
