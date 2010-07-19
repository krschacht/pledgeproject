require 'test_helper'

class PledgeTest < ActiveSupport::TestCase

  test "pledges attributes must not be empty" do
    pledge = Pledge.new

    assert pledge.invalid?
    assert pledge.errors[:project_id].any?
    assert pledge.errors[:first_name].any?
    assert pledge.errors[:last_name].any?
    assert pledge.errors[:email].any?
    assert pledge.errors[:amount].any?
  end
  
  test "successful creation and linking of pledges and projects" do
    fields = {
      :project_id => projects(:letter).id,
      :first_name => "Keith",
      :last_name => "Schacht",
      :email => "krschacht@gmail.com",
      :amount => 50.00
    }
    pledge = Pledge.create( fields )
    assert !pledge.invalid?

    assert_equal pledge.project, projects(:letter)
    assert_equal projects(:letter).pledges.length, 2      # there is already one pledge in the fixture
    assert_equal projects(:letter).pledges.first, pledge
  end

end
