
class PaypalPaymentTransaction < PremiumTransaction

  def self.record( postback_params )
    
    transaction do
      pledge = Pledge.find( postback_params[ "item_number" ] )
            
      p = create!(  :user_id    => 0,
                    :pledge     => pledge,
                    :amount     => postback_params[ "payment_gross" ] )

      pledge.new_payment_transaction( p )
      
      PaypalPostback.create_from_request_params(
          postback_params.merge( 'premium_transaction_id' => p.id ) 
      )
      
      p
    end
  end

end

