class AddPaidFlagToPledges < ActiveRecord::Migration
  def self.up
    add_column :pledges, :paid, :boolean, :default => false
  end

  def self.down
    remove_column :pledges, :paid
  end
end
