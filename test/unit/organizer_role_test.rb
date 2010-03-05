require File.dirname(__FILE__) + '/../test_helper'

class OrganizerRoleTest < ActiveSupport::TestCase

  test "create a role" do
    assert_difference 'OrganizerRole.count' do
      OrganizerRole.create!(:title => "blah blah new title")
    end
  end
  
  test "destroy a role" do
    org = OrganizerRole.create!(:title => "blah blah new title")
    assert_difference 'OrganizerRole.count', -1 do
      org.destroy
    end
  end
  
  #test "cannot destroy a role with dependent organizers" do
  #  assert !founder.organizers.empty?
  #  assert_raise(ActiveRecord::StatementInvalid){founder.destroy}
  #end
  
end
