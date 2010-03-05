require File.dirname(__FILE__) + '/../test_helper'

class IgniteTest < ActiveSupport::TestCase
  context "An unsaved ignite" do
    setup do 
      @ignite = Factory.build(:ignite)
    end
    subject { @ignite }
    should_validate_presence_of :city, :domain
    
    context 'when saved' do
      setup do
        @ignite.save!
      end
      should_change("number of ignites", :by => 1) { Ignite.count }
      should_change("number of events", :by => 1) { Event.count }
      should "create and feature the first event" do
        assert_not_nil @ignite.reload.featured_event
      end
      
      should 'not allow another ignite with the same domain to be created' do
        assert !Factory.build(:ignite, :domain => @ignite.domain).valid?
      end
    end
  end
end
