class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string    :title
      t.text      :description
      t.string    :url
      t.integer   :num_pledges
      t.decimal   :total_pledges
      t.timestamp :pledge_deadline_at
      t.string    :method
      t.decimal   :pledge_goal_amount,    :scale => 2
      t.decimal   :current_pledge_total,  :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
