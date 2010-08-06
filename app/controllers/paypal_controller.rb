class PaypalController < ApplicationController

  protect_from_forgery :except => [ :postback ]

  def postback
    # begin
    #   PaypalPaymentTransaction.record( params )
    # 
    #   render :text => "OK"
    # rescue => e
    #   notify_hoptoad( e )
    #   render :text => "ERROR:RESEND"
    # end

    PaypalPaymentTransaction.record( params )
    
    render :text => "OK"
  end

end
