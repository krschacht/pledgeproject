class ProjectNotifier < ActionMailer::Base

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.actionmailer.admin_notifier.pledge_received.subject
  #
  def pledge_received( pledge )
    @pledge = pledge
    u = pledge.project.user

    mail  :from       => "#{pledge.full_name} <#{pledge.email}>",
          :sender     => pledge.email,
          :reply_to   => pledge.email,
          :reply_path => App.system_email,
          :to         => u.email, 
          :subject => "Pledge Received - #{ pledge.full_name } - #{ pledge.project.title }"
  end
end
