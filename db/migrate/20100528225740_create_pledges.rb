class CreatePledges < ActiveRecord::Migration
  def self.up
    create_table :pledges do |t|
      t.integer :project_id
      t.string  :first_name
      t.string  :last_name
      t.string  :email
      t.decimal :amount
      t.text    :note

      t.timestamps
    end
  end

  def self.down
    drop_table :pledges
  end
end
