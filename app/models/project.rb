class Project < ActiveRecord::Base
  default_scope :order => 'id asc'  
  
  belongs_to :user
  has_many :pledges, :order => 'created_at ASC'
  
  validates :title, :presence => true
  
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
  
  def perct_raised
    return 0  if method != :goal || self.current_pledged_total.nil? || self.pledge_goal_amount.nil?
    
    perct = ( self.current_pledged_total / self.pledge_goal_amount.to_f )
    perct = 1.0   if perct > 1.0
    
    perct
  end
  
  def method
    self[:method].to_sym  unless self[:method].nil? || self[:method].empty?
  end
  
  def url_friendly_title
    self.title.gsub(/[^A-Za-z0-9]/, '_')
  end
  
  def status
    self[:status].to_sym
  end
  
  def closed?
    status == :closed
  end

  def to_s
    "project_#{self.id}"
  end
  
end
