class Project < ActiveRecord::Base
  
  def perct_raised
    return 0  if method != :goal || self.current_pledge_total.nil? || self.pledge_goal_amount.nil?
    
    ( self.current_pledge_total / self.pledge_goal_amount.to_f )
  end
  
  def method
    self[:method].to_sym  unless self[:method].nil? || self[:method].empty?
  end
  
  def url_friendly_title
    self.title.gsub(/[^A-Za-z0-9]/, '_')
  end
  
end
