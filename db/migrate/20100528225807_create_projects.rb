class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.integer :num_pledges
      t.decimal :total_pledges
      t.timestamp :pledge_deadline_at

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
