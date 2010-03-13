require File.dirname(__FILE__) + '/../test_helper'

class OrganizerTest < ActiveSupport::TestCase
  context 'a saved organizer' do
    setup do
      @organizer = Factory(:organizer)
    end
    subject { @organizer }
    should_validate_presence_of :ignite_id, :name
    
    context "with an event" do
      setup do
        @event = Factory(:event, :ignite => @organizer.ignite)
      end
      
      should "be able to add an event" do
        @organizer.events << @event
      end
      
      should "not be able to add the same event twice" do
        @organizer.events << @event
        assert_raise(ActiveRecord::StatementInvalid) { @organizer.events << @event }
      end
    end
  end
  
  context 'a saved organizer assigned to an event' do
    setup do
      @organizer = Factory(:organizer)
      @event = Factory(:event, :ignite => @organizer.ignite)
      @organizer.events << @event
    end
    should 'be able to delete' do
      assert_nothing_raised { @organizer.destroy }
      assert_equal 0, @event.reload.organizers.count
    end
  end
end
