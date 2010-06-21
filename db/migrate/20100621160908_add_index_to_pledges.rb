class AddIndexToPledges < ActiveRecord::Migration
  def self.up
    add_index :pledges, :project_id
  end

  def self.down
    remove_index :pledges, :project_id
  end
end
