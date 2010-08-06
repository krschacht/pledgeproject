require 'test_helper'

class PaypalPostbackTest < ActionController::IntegrationTest
  fixtures :all

  test "Paypal postback" do
    
    prev_id           = PaypalPaymentTransaction.maximum(:id).to_i
    prev_amount_paid  = pledges(:john).amount_paid
    prev_num_txn      = pledges(:john).premium_transactions.length
    
    pay = 1.25
    
    params = {"tax"=>"0.00", "payment_status"=>"Completed", "address_name"=>"Crafted Fun, Inc.", "address_city"=>"Chicago", "payer_business_name"=>"Crafted Fun, Inc.", "receiver_email"=>"krschacht@gmail.com", "address_zip"=>"60605", "business"=>"krschacht@gmail.com", "address_country"=>"United States", "quantity"=>"1", "receiver_id"=>"7CZGFPHTFRSD8", "transaction_subject"=>"Pledge project", "payment_gross"=>"#{ pay }", "notify_version"=>"3.0", "payment_fee"=>"0.33", "mc_currency"=>"USD", "address_street"=>"600 S. Dearborn #2107", "address_country_code"=>"US", "verify_sign"=>"An5ns1Kso7MWUdW4ErQKJJJ4qi4-AuXL5qiKl5hsgwjKaxeWzoDWu6wm", "txn_id"=>"5DG875162L831713V", "item_name"=>"Pledge project", "shipping"=>"0.00", "txn_type"=>"web_accept", "mc_gross"=>"1.00", "address_status"=>"confirmed", "payer_id"=>"XTG28P4NZ42FG", "charset"=>"windows-1252", "mc_fee"=>"0.33", "last_name"=>"Schacht", "custom"=>"", "payer_status"=>"verified", "address_state"=>"IL", "protection_eligibility"=>"Eligible", "payment_date"=>"18:43:45 Aug 05, 2010 PDT", "payer_email"=>"billing@craftedfun.com", "residence_country"=>"US", "handling_amount"=>"0.00", "first_name"=>"Keith", "payment_type"=>"instant", "item_number"=>"#{ pledges(:john).id }"} 
    
    post '/paypal/postback', params
    assert_response :success
    
    t = PaypalPaymentTransaction.find( prev_id + 1 )

    assert ! t.nil?
    assert_equal t.pledge, pledges(:john)
    assert_equal t.amount, 1.25
    assert ! t.paypal_postback.nil?
    assert_equal t.paypal_postback.payer_business_name, "Crafted Fun, Inc."
    assert_equal t.paypal_postback.payer_email, "billing@craftedfun.com"
    assert_equal t.paypal_postback.payment_status, "Completed"
    assert_equal t.paypal_postback.receiver_email, "krschacht@gmail.com"
    assert_equal t.paypal_postback.business, "krschacht@gmail.com"
    assert_equal t.paypal_postback.payment_gross, pay
    assert_equal t.paypal_postback.txn_id, "5DG875162L831713V"
    params.keys.each do |key|
      raw = YAML.load( t.paypal_postback.raw )
      assert raw.include? key
    end
    assert_equal t.pledge.premium_transactions.length, prev_num_txn+1
    assert_equal t.pledge.amount_paid.to_f,  prev_amount_paid+pay
    assert ! t.pledge.paid_in_full?

    # Do a second payment to make this pledge totally paid up
    params["payment_gross"] = t.pledge.amount_remaining.to_f

    post '/paypal/postback', params
    assert_response :success

    assert Pledge.find( pledges(:john).id ).paid_in_full?    
  end
end