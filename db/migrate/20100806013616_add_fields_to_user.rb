class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :paypal_email, :string
    add_column :users, :pledge_invoice_subject, :string
    add_column :users, :pledge_invoice_body, :text
    
    User.all.each { |u| u.paypal_email = u.email; u.save! }
  end

  def self.down
    remove_column :users, :paypal_email
    remove_column :users, :pledge_invoice_subject
    remove_column :users, :pledge_invoice_body
  end
end
