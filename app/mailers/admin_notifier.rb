class AdminNotifier < ActionMailer::Base
  default :from => "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.actionmailer.admin_notifier.pledge_received.subject
  #
  def pledge_received( pledge )
    @pledge = pledge

    mail :to => "krschacht@gmail.com", :subject => "Pledge Received - #{ @pledge.full_name } - #{ @pledge.project.title }"
  end
end
