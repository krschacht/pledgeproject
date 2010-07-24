class User < ActiveRecord::Base

# http://blog.steveklabnik.com/writing-a-su-feature-with-authlogic

  acts_as_authentic do |c| 
    login_field :email 
    validate_login_field :false 
  end  

  validates :first_name, :last_name, :site_name, :from_email, 
            :pledge_confirmation_subject, :pledge_confirmation_body,
              :presence => true
  
  has_many :projects
  has_many :groups

  def full_name
    self.first_name + " " + self.last_name
  end
  
end
