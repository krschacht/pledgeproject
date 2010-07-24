class Vote < ActiveRecord::Base

  belongs_to :group
  has_many :pledges

  accepts_nested_attributes_for :pledges
  
  def pledge
    self.pledges.first
  end

end
