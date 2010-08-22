class AddPaymentFieldsToPledge < ActiveRecord::Migration
  
  def self.up
    add_column :pledges, :user_id, :integer
    add_column :pledges, :invoice_queued_at, :datetime
    add_column :pledges, :payment_requested_at, :datetime
    add_column :pledges, :paid_in_full_at, :datetime
    add_column :pledges, :amount_paid, :decimal, :precision => 10, :scale => 2, :default => 0.00
    rename_column :pledges, :amount, :amount_pledged
    change_column :pledges, :amount_pledged, :decimal, { :precision => 10, :scale => 2 }
    remove_column :pledges, :paid
  end

  def self.down
    remove_column :pledges, :user_id
    remove_column :pledges, :invoice_queued_at
    remove_column :pledges, :payment_requested_at
    remove_column :pledges, :paid_in_full_at
    remove_column :pledges, :amount_paid
    rename_column :pledges, :amount_pledged, :amount
    add_column :pledges, :paid, :boolean
  end
  
end
