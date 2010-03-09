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
  
  context "With a featured and unfeatured event" do
    setup do
      @featured_event   = Factory(:featured_event)
      @unfeatured_event = Factory(:event, :ignite => @featured_event.ignite, :date => Date.today + 90)
    end
    
    context "when creating a new event that will be featured" do
      setup do
        @new_event = Factory(:featured_event, :ignite => @featured_event.ignite)
      end
      should_change("previously featured event", :from => true, :to => false) { Event.find(@featured_event.id).is_featured? }
      should "make new event featured" do
        assert @new_event.is_featured?
      end
      should "leave only one featured event" do
        assert_equal 1, @unfeatured_event.ignite.events.find(:all, :conditions => {:is_featured => true}).size
      end
    end
    
    context "when updating the unfeatured event to be featured" do
      setup do
        @unfeatured_event.update_attributes!(:is_featured => true)
      end
      should_change("previously featured event", :from => true, :to => false) { Event.find(@featured_event.id).is_featured? }
      should_change("updated event to featured", :from => false, :to => true) { @unfeatured_event.is_featured? }
    end
    
    context "when updating the featured event to be unfeatured" do
      setup do
        @featured_event.update_attributes(:is_featured => false)
      end
      should_not_change("featured event") { Event.find(@featured_event.id).is_featured? }
      should "add an error" do
        assert_equal 1, @featured_event.errors.size
      end
    end
    
    context "when destroying the featured event" do
      setup do
        @featured_event.destroy
      end
      should_change("number of features", :by => -1) { @featured_event.ignite.events.count }
      should "make the unfeatured event featured" do
        assert Event.find(@unfeatured_event).is_featured?
      end
    end
  end
  
  context "With only a featured event" do
    setup do
      ignite = Factory(:ignite)
      @event = ignite.featured_event
    end
    should "raise an error when trying to destroy it" do
      assert_raise(StandardError) { @event.destroy }
    end
  end
end
