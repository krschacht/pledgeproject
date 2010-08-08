# FB
# http://stackoverflow.com/questions/1072160/using-facebook-connect-with-authlogic
# http://groups.google.com/group/authlogic/browse_thread/thread/ed0ec364ae90ac23
# http://stackoverflow.com/questions/2946324/how-to-integrate-facebook-the-new-graph-api-with-authlogic-in-ruby-on-rails
# http://stackoverflow.com/questions/3066031/facebook-graph-api-with-rails-and-authlogic-preferred-methodology
# http://developers.facebook.com/docs/guides/web
# http://developers.facebook.com/docs/reference/plugins/comments
# http://web1.tunnlr.com:10107/test.html
# http://developers.facebook.com/setup/done?id=138563892831947&locale=en_US

class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def new
    @user = User.new
    
    @user.pledge_confirmation_subject = "You've made a pledge!"
    @user.pledge_confirmation_body = <<-END
Hi @PLEDGE_FIRST_NAME@,

I've received your pledge(s) of @PLEDGE_AMOUNTS@ for the project(s) @PLEDGE_PROJECT_TITLES@. Thank you so much for your support!

I'll post updates about the project(s) to @SITE_NAME@, and I'll e-mail you any important news too. Remember, you don't owe any money until a project receives enough money to get started. If and when that happens, I'll e-mail you an invoice.

If you have any questions, you can e-mail me by replying to this message.

Thanks again for your support!

@USER_FULL_NAME@
END

    @user.pledge_invoice_subject = "Invoice for your pledge"
    @user.pledge_invoice_body = <<-END
Dear @PLEDGE_FIRST_NAME@,

Thank you so much for pledging for the @PLEDGE_PROJECT_TITLE@. The project has been completed, here is your invoice.

You pledged @PLEDGE_AMOUNT@.

Click here to pay me via PayPal:

@INVOICE_URL@

(If you're not satisfied with the project, I will give you a refund, provided that you explain your reasons.)

Thank you again for supporting my work.  I appreciate that more than I can say!

@USER_FULL_NAME@
END

  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default admin_url
    else
      render :action => :new
    end
  end
  
  def show
    @show_admin_nav = true
    @user = @current_user
  end

  def edit
    @show_admin_nav = true
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated."
      redirect_to admin_url
    else
      render :action => :edit
    end
  end
end
