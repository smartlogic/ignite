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
end
