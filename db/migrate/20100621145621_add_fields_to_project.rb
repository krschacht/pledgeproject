class AddFieldsToProject < ActiveRecord::Migration
  def self.up
    add_column    :projects,  :pledge_done_url, :string

    remove_column :projects,  :total_pledges

    change_column :projects,  :num_pledges,          :integer, :default => 0
    change_column :projects,  :current_pledge_total, :decimal, :default => 0, :scale => 2, :precision => 10
    change_column :projects,  :pledge_goal_amount,   :decimal, :scale => 2, :precision => 10

    rename_column :projects,  :current_pledge_total, :current_pledged_total
    rename_column :projects,  :num_pledges,          :pledges_count
  end

  def self.down
    remove_column :projects,  :pledge_done_url

    add_column    :projects,  :total_pledges,         :integer

    rename_column :projects,  :current_pledged_total, :current_pledge_total
    rename_column :projects,  :pledges_count,         :num_pledges
  end
end
