require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  test "project attributes must not be empty" do
    project = Project.new
    assert project.invalid?
    assert project.errors[:title].any?
  end
  
  test "project properly tracks pledges" do
    podcast = Project.create( :title => "Finding a romantic partner podcast")

    assert !podcast.invalid?
    
    keith = Pledge.create(    
      :project_id => podcast.id,
      :first_name => "Keith",
      :last_name => "Schacht",
      :email => "krschacht@gmail.com",
      :amount => 25.00
    )

    pari = Pledge.create(
      :project_id => podcast.id,
      :first_name => "Pari",
      :last_name => "Schacht",
      :email => "pari@nurturingwisdom.com",
      :amount => 35.00
    )

    podcast = Project.find( podcast.id )

    assert_equal podcast.pledges.length, 2
    assert_equal podcast.pledges_count, 2
    assert_equal podcast.current_pledged_total, 60
    
    keith.destroy
    podcast = Project.find( podcast.id )

    assert_equal podcast.pledges.length, 1
    assert_equal podcast.pledges_count, 1
    assert_equal podcast.current_pledged_total, 35
    
  end
  
end
