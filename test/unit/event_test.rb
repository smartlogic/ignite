require File.dirname(__FILE__) + '/../test_helper'

class EventTest < ActiveSupport::TestCase
  context "With an unsaved event" do
    setup do
      @event = Factory.build(:event)
    end
    subject { @event }
    should_validate_presence_of :ignite_id
    
    should "be past if date is in the past" do
      @event.date = Date.today - 30
      assert @event.past?
    end
    should "be past if is_complete is true" do
      @event.is_complete = true
      assert @event.past?
    end
    should "not be past if is_complete is false and date is in the future" do
      @event.is_complete = false
      @event.date = Date.today + 30
      assert !@event.past?
    end
  end
end
