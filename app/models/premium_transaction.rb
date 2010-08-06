class PremiumTransaction < ActiveRecord::Base

  belongs_to :pledge
  has_one :paypal_postback
  
  def self.types
    @types ||= [ PaypalPaymentTransaction ]
  end
    
end
