class GroupNotifier < ActionMailer::Base

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.actionmailer.admin_notifier.pledge_received.subject
  #
  def vote_received( vote )
    @vote = vote
    u = vote.group.project.user

    mail  :from       => "#{vote.pledge.full_name} <#{vote.pledge.email}>",
          :sender     => vote.pledge.email,
          :reply_to   => vote.pledge.email,
          :reply_path => App.system_email,
          :to         => u.email, 
          :subject => "Pledge Received - #{ vote.pledge.full_name } - #{ vote.group.title }"
  end
end
