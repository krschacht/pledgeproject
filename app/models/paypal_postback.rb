
class PaypalPostback < ActiveRecord::Base

  belongs_to :premium_transaction

  VALID_PARAMS = %w( payer_business_name payer_email payment_status receiver_email business payment_gross payment_status txn_id premium_transaction_id )

  def self.create_from_request_params( params )
    p = params.reject { |k,v| ! VALID_PARAMS.include?( k ) }
    create!( p.merge( :raw => params.to_yaml ) )
  end

end

