
class PaypalPaymentRequest
  
  def initialize( opts={} )
    @vars = opts
    @vars[:cmd]             = '_xclick'
    @vars[:currency_code]   = 'USD'
    @vars[:button_subtype]  = 'services'
    @vars[:no_note]         = 0
    @vars[:lc]              = 'US'
    @vars[:no_shipping]     = 1
    @vars[:rm]              = 1
    @vars[:bn]              = 'PP-BuyNowBF:btn_buynowCC_LG.gif:NonHosted'
    @vars[:notify_url]      = 'http://web1.tunnlr.com:10107/paypal/done'

    @vars = @vars.merge(
      :business => 'krschacht@gmail.com',
      :item_name => 'Pledge project',
      :amount => 1.00,
      :cn => 'Comments about this payment (optional)',
      :return => 'http://localhost:3000/completed',
      :cancel => 'http://localhost:3000/cancel'
    )

    @base = 'https://www.paypal.com/cgi-bin/webscr'
  end
    
  def url    
    params = @vars.to_a.inject('') { |v,a| v+="#{ a[0] }=#{ url_encode(a[1]) }&" }
    
    @base + '?' + params
  end
      
  def url_encode( s )
    URI.escape( s.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]") )
  end

end