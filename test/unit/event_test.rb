require File.dirname(__FILE__) + '/../test_helper'

class EventTest < ActiveSupport::TestCase
  context "With an unsaved event" do
    setup do
      @event = Factory.build(:event)
    end
    subject { @event }
    should_validate_presence_of :ignite_id
  end
end
