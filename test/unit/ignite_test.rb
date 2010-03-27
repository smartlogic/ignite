require File.dirname(__FILE__) + '/../test_helper'

class IgniteTest < ActiveSupport::TestCase
  context "With a saved ignite" do
    setup do 
      @ignite = Factory(:ignite)
    end
    subject { @ignite }
    should_validate_presence_of :city, :domain
    should_validate_uniqueness_of :domain
    
    should "return 2 for next_event_position" do
      assert_equal 2, @ignite.send(:next_event_position)
    end
  end
  
  context '#emails_as_array' do
    should 'return empty array for nil email notification' do
      @ignite = Factory(:ignite, :emails => nil)
      assert_equal [], @ignite.emails_as_array
    end
    
    should 'return empty array for empty email notification' do
      @ignite = Factory(:ignite, :emails => '')
      assert_equal [], @ignite.emails_as_array
    end
    
    should 'split on commas and strip whitespace' do
      @ignite = Factory(:ignite, :emails => 'john@slsdev.net, nick@slsdev.net')
      assert_equal ['john@slsdev.net', 'nick@slsdev.net'], @ignite.emails_as_array
    end
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
  
  context "With an ignite without any events" do
    setup do
      Ignite.without_callbacks do 
        @ignite = Factory(:ignite)
      end
    end
    should "return 1 for next_event_position" do
      assert_equal 1, @ignite.send(:next_event_position)
    end
  end
end
