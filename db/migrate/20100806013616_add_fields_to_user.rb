class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :paypal_email, :string
    add_column :users, :pledge_invoice_subject, :string
    add_column :users, :pledge_invoice_body, :text
    
    User.all.each do |u| 
      u.paypal_email = u.email
      u.pledge_invoice_subject = "Invoice for your pledge"
      u.pledge_invoice_body = <<-END
Dear @PLEDGE_FIRST_NAME@,

Thank you so much for pledging for the @PLEDGE_PROJECT_TITLE@. The project has been completed, here is your invoice.

You pledged @PLEDGE_AMOUNT@.

Click here to pay me via PayPal:

@INVOICE_URL@

(If you're not satisfied with the project, I will give you a refund, provided that you explain your reasons.)

Thank you again for supporting my work.  I appreciate that more than I can say!

@USER_FULL_NAME@
END
      u.save!
    end
    
  end

  def self.down
    remove_column :users, :paypal_email
    remove_column :users, :pledge_invoice_subject
    remove_column :users, :pledge_invoice_body
  end
end
