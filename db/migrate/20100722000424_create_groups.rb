class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.integer :user_id
      t.string  :title
      t.string  :project_ids
      t.string  :vote_done_url

      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
