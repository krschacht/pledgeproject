class AddSubAndNoteToPledge < ActiveRecord::Migration
  def self.up
    add_column :pledges, :subscribe_me, :boolean, :default => true
    add_column :pledges, :internal_note, :string
  end

  def self.down
    remove_column :pledges, :internal_note
    remove_column :pledges, :subscribe_me
  end
end
