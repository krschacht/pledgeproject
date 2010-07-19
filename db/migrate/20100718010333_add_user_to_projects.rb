class AddUserToProjects < ActiveRecord::Migration
  def self.up
    add_column    :projects,  :user_id, :integer

    # A user = 1 does not actually exist yet but any existing projects will 
    # be owned by the first user that is created after this migration is run
    Project.all.each { |p| p.update_attribute( :user_id, 1 ) } 
  end

  def self.down
    remove_column    :projects,  :user_id
  end
  
end
