class User < ActiveRecord::Base

  acts_as_authentic do |c| 
    login_field :email 
    validate_login_field :false 
  end  
  
  has_many :projects

  def full_name
    self.first_name + " " + self.last_name
  end
  
end
