class User < ActiveRecord::Base

  acts_as_authentic do |c| 
    login_field :email 
    validate_login_field :false 
  end  
  
  has_many :projects
    
end