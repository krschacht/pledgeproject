class CreatePaypalPostbacks < ActiveRecord::Migration
  def self.up
    create_table :paypal_postbacks do |t|
      t.integer :premium_transaction_id
      t.string :payer_business_name
      t.string :payer_email
      t.string :payment_status
      t.string :receiver_email
      t.string :business
      t.decimal :payment_gross, :precision => 10, :scale => 2
      t.string :payment_status
      t.string :txn_id
      t.text :raw

      t.timestamps
    end
  end

  def self.down
    drop_table :paypal_postbacks
  end
end
