require 'test_helper'

class PledgeTest < ActiveSupport::TestCase

  test "pledges attributes must not be empty" do
    pledge = Pledge.new

    assert pledge.invalid?
    assert pledge.errors[:project_id].any?
    assert pledge.errors[:first_name].any?
    assert pledge.errors[:last_name].any?
    assert pledge.errors[:email].any?
    assert pledge.errors[:amount_pledged].any?
  end
  
  test "successful creation and linking of pledges and projects" do
    fields = {
      :project_id       => projects(:letter).id,
      :first_name       => "Keith",
      :last_name        => "Schacht",
      :email            => "krschacht@gmail.com",
      :amount_pledged   => 50.00
    }
    num_pledges = projects(:letter).pledges.length
    
    pledge = Pledge.create( fields )
    assert !pledge.invalid?

    assert_equal pledge.project, projects(:letter)
    assert_equal Project.find( projects(:letter).id ).pledges.length, num_pledges+1
    assert Project.find( projects(:letter).id ).pledges.include? pledge
  end

end
