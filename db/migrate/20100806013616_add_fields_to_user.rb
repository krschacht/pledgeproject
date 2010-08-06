class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :paypal_email, :string
    
    User.all.each { |u| u.paypal_email = u.email; u.save! }
  end

  def self.down
    remove_column :users, :paypal_email
  end
end
