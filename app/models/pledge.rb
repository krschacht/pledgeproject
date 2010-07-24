class WordCountValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    
    if value && value.scan(/[\w-]+/).size > options[:less_than_or_equal_to]
      record.errors[attribute] << "must be less than #{options[:less_than_or_equal_to]} words"
    end
  end
end


class Pledge < ActiveRecord::Base

  belongs_to :project
  
  validates :project_id, :first_name, :last_name, :email, :amount, :presence => true
  validates :amount, :numericality => { :greater_than_or_equal_to => 0.0 }
  validates :note, :word_count => { :less_than_or_equal_to => 200 }

  after_create  :pledge_added
  after_destroy :pledge_removed
  after_update  :pledge_updated
  
  scope :for_project, lambda {|id| where(:project_id => id) }
   
  def full_name
    self.first_name + ' ' + self.last_name
  end
  
  def pledge_added
    p = Project.find( self.project_id )
    
    if p
      p.pledges_count += 1
      p.current_pledged_total += self.amount      
      p.save!
    end
  end
  
  def pledge_removed
    p = Project.find( self.project_id )
    
    if p
      p.pledges_count -= 1
      p.current_pledged_total -= self.amount
      
      p.pledges_count = 0             if p.pledges_count < 0
      p.current_pledged_total = 0     if p.current_pledged_total < 0
      p.save!
    end
  end

  def pledge_updated
    p = Project.find( self.project_id )

    if p
      p.current_pledged_total = Pledge.for_project( self.project_id ).sum( :amount )
      p.save!
    end
  end

end
