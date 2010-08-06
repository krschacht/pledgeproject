class WordCountValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    
    if value && value.scan(/[\w-]+/).size > options[:less_than_or_equal_to]
      record.errors[attribute] << "must be less than #{options[:less_than_or_equal_to]} words"
    end
  end
end


class Pledge < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :premium_transactions
  
  validates :project_id, :first_name, :last_name, :email, :amount_pledged, :presence => true
  validates :amount_pledged, :numericality => { :greater_than_or_equal_to => 0.0 }
  validates :note, :word_count => { :less_than_or_equal_to => 200 }

  after_create  :pledge_added
  after_destroy :pledge_removed
  after_update  :pledge_updated
  
  scope :for_project, lambda {|id| where(:project_id => id) }
   
  def full_name
    first_name + ' ' + last_name
  end
  
  def payment_requested?
    ! payment_requested_at.nil?
  end
  
  
  def pledge_added
    p = Project.find( self.project_id )
    
    if p
      p.pledges_count += 1
      p.current_pledged_total += self.amount_pledged      
      p.save!
    end
  end
  
  def pledge_removed
    p = Project.find( self.project_id )
    
    if p
      p.pledges_count -= 1
      p.current_pledged_total -= self.amount_pledged
      
      p.pledges_count = 0             if p.pledges_count < 0
      p.current_pledged_total = 0     if p.current_pledged_total < 0
      p.save!
    end
  end

  def pledge_updated
    p = Project.find( self.project_id )

    if p
      p.current_pledged_total = Pledge.for_project( self.project_id ).sum( :amount_pledged )
      p.save!
    end
  end
  
  def new_payment_transaction( p )
    amount_paid += p.amount
    paid_in_full_at = Time.now  if amount_paid >= amount_pledged
    save!
  end
  
end
