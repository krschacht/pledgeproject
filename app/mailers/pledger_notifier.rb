class PledgerNotifier < ActionMailer::Base

  def pledge_received( pledge )
    @pledge = pledge
    @project_user = pledge.project.user

    @body_text = @project_user.pledge_confirmation_body
    @body_text.gsub!( /@PLEDGE_FIRST_NAME@/, @pledge.first_name )
    @body_text.gsub!( /@PLEDGE_AMOUNT@/, @pledge.amount.to_s )
    @body_text.gsub!( /@PLEDGE_PROJECT_TITLE/, @pledge.project.title )
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
