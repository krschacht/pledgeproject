class EmailJob < Struct.new(:klass, :method, :params)
  def perform      
    mail = "#{klass}".to_s.classify.constantize.send(method, params).deliver!
  end 
end

# Delayed::Job.enqueue Jobs::EmailJob.new(:pledge_notifier, :invoice_custom, params ) 
# which forwards the call to PledgeNotifier.invoice_custom( params )