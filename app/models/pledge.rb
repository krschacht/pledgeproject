class WordCountValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    
    if value.scan(/[\w-]+/).size > options[:less_than_or_equal_to]
      record.errors[attribute] << "must be less than #{options[:less_than_or_equal_to]} words"
    end
  end
end


class Pledge < ActiveRecord::Base
  
  validates :project_id, :first_name, :last_name, :email, :amount, :presence => true
  validates :amount, :numericality => { :greater_than_or_equal_to => 0.01 }
  validates :note, :word_count => { :less_than_or_equal_to => 200 }

  after_create  :pledge_added
  after_destroy :pledge_removed
  
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
      p.save!
    end
  end
  
end
