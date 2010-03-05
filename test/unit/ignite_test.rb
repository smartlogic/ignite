require File.dirname(__FILE__) + '/../test_helper'

class IgniteTest < ActiveSupport::TestCase
  context "With a saved ignite" do
    setup do 
      @ignite = Factory(:ignite)
    end
    subject { @ignite }
    should_validate_presence_of :city, :domain
    should_validate_uniqueness_of :domain
  end
  
  context "With an unsaved ignite" do
    setup do 
      @ignite = Factory.build(:ignite)
    end
    context 'when saved' do
      setup do
        @ignite.save!
      end
      should_change("number of ignites", :by => 1) { Ignite.count }
      should_change("number of events", :by => 1) { Event.count }
      should "create and feature the first event" do
        assert_not_nil @ignite.reload.featured_event
      end
    end
  end
end
