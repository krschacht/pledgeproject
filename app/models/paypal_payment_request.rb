
class PaypalPaymentRequest
 
  def initialize( pledge )    
    @vars = {}
    @vars[:business]        = pledge.project.user.paypal_email
    @vars[:item_name]       = pledge.project.title
#    @vars[:amount]          = pledge.amount_pledged.to_f
    @vars[:item_number]     = pledge.id
    
    @vars[:cmd]             = '_xclick'
    @vars[:currency_code]   = 'USD'
    @vars[:button_subtype]  = 'services'
    @vars[:no_note]         = 0
    @vars[:lc]              = 'US'
    @vars[:no_shipping]     = 1
    @vars[:rm]              = 1
    @vars[:bn]              = 'PP-BuyNowBF:btn_buynowCC_LG.gif:NonHosted'
    @vars[:cn]              = 'Comments about this payment (optional)'  
    @vars[:return]          = App.url_base + "projects/#{pledge.project.id}/pledges/new"
    @vars[:cancel]          = App.url_base + "projects/#{pledge.project.id}/pledges/new"
    
    if RAILS_ENV == "development"
      @vars[:notify_url]      = App.url_base + "paypal/postback"
    else
      @vars[:notify_url]      = App.url_base + "paypal/postback"
    end

    # @vars = @vars.merge(
    #   :business => 'krschacht@gmail.com',
    #   :item_name => 'Pledge project',
    #   :amount => 1.50,
    #   :return => 'http://localhost:3000/completed',
    #   :cancel => 'http://localhost:3000/cancel',
    #   :item_number => @vars[:pledge_id]
    # )
    
    @vars.delete(:pledge_id)

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