class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def new
    @user = User.new
    
    @user.pledge_confirmation_subject = "You've made a pledge!"
    @user.pledge_confirmation_body = <<-END
Hi @PLEDGE_FIRST_NAME@,

I've received your pledge of $@PLEDGE_AMOUNT@ for the project '@PLEDGE_PROJECT_TITLE@'. Thank you so much for your support of this work!

I'll post updates about this project to @SITE_NAME@, and I'll e-mail you any important news too.  Remember, you don't owe any money until the project is completed.  If and when that happens, I'll e-mail you an invoice.

If you have any questions, you can e-mail me by replying to this message.

Thanks again for your support!

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
    @user = @current_user
  end

  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end
