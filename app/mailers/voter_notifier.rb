class VoterNotifier < ActionMailer::Base

  def vote_received( vote )
    @vote = vote
    @project_user = vote.group.project.user

    @body_text = @project_user.pledge_confirmation_body
    @body_text.gsub!( /@PLEDGE_FIRST_NAME@/, @vote.pledge.first_name )
    @body_text.gsub!( /@PLEDGE_AMOUNT@/, @vote.pledge.amount.to_s )
    @body_text.gsub!( /@PLEDGE_PROJECT_TITLE@/, @vote.group.title )
    @body_text.gsub!( /@SITE_NAME@/, @project_user.site_name )
    @body_text.gsub!( /@USER_FULL_NAME@/, @project_user.full_name )

    mail  :from       => "#{ @project_user.full_name } <#{ @project_user.from_email }>",
          :sender     => @project_user.from_email,
          :reply_to   => @project_user.from_email,
          :reply_path => App.system_email,
          :to         => "#{ @vote.pledge.full_name } <#{ @vote.pledge.email }>", 
          :subject    => @project_user.pledge_confirmation_subject
  end

end
