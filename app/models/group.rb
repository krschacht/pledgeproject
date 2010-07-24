class Group < ActiveRecord::Base

  has_many :votes
  
  validates :title, :project_ids, :presence => true

  def projects
    ids = self.project_ids.split(',')
    ids.map { |i| Project.find( i.to_i ) }
  end

  def project
    projects.first
  end
  
end
