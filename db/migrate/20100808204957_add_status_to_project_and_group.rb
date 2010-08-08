class AddStatusToProjectAndGroup < ActiveRecord::Migration

  def self.up
    add_column :projects, :status, :text
    add_column :projects, :closed_msg, :text
    add_column :groups, :status, :text
    add_column :groups, :closed_msg, :text
    
    Project.all.each do |p| 
      p.status = 'open'; 
      p.closed_msg = 'Pledging has been closed.'
      p.save!
    end
    Group.all.each do |g| 
      g.status = 'open'; 
      g.closed_msg = 'Pledging has been closed.'
      g.save!
    end
  end

  def self.down
    remove_column :projects, :status
    remove_column :projects, :closed_msg
    remove_column :groups, :status
    remove_column :groups, :closed_msg
  end
end
