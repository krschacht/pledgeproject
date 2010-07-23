class AddVoteIdToPledge < ActiveRecord::Migration
  def self.up
    add_column :pledges, :vote_id, :integer
  end

  def self.down
    remove_column :pledges, :vote_id
  end
  
end
