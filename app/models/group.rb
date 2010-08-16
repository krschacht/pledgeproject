class Group < ActiveRecord::Base

  has_many :votes
  
  validates :title, :project_ids, :presence => true

  def self.create( hash )
    status = hash.delete(:status) || hash.delete('status') || 'open'    
    hash.merge!( :status => status )
    super hash
  end

  def self.create!( hash )
    status = hash.delete(:status) || hash.delete('status') || 'open'    
    hash.merge!( :status => status )
    super hash
  end  

  def projects
    ids = self.project_ids.split(',')
    ids.map { |i| Project.find( i.to_i ) }
  end

  def project
    projects.first
  end
  
  def status
    (self[:status] || 'open').to_sym
  end
  
  def closed?
    status == :closed
  end
  
end
