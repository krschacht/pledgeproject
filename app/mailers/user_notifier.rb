class UserNotifier < ActionMailer::Base
  default :from => "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.actionmailer.user_notifier.pledge_received.subject
  #
  def pledge_received( pledge )
    @pledge = pledge

    mail :to => pledge.email, :subject => "You've made a pledge!"
  end
end
