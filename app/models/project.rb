class Project < ActiveRecord::Base

  has_many :pledges
  
  validates :title, :presence => true

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
  
end
