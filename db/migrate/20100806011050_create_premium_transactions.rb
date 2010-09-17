class CreatePremiumTransactions < ActiveRecord::Migration
  def self.up
    create_table :premium_transactions do |t|
      t.integer :pledge_id
      t.integer :user_id
      t.string :type
      t.decimal :amount, :precision => 10, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :premium_transactions
  end
end
