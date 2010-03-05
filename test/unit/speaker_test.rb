require File.dirname(__FILE__) + '/../test_helper'

class SpeakerTest < ActiveSupport::TestCase
  context "With a saved speaker" do
    setup do
      @speaker = Factory(:speaker)
    end
    subject { @speaker }
    should_validate_presence_of :name, :title, :description, :bio, :ignite_id
  end
  
  context "With three speakers" do
    setup do
      3.times { Factory(:speaker) }  
    end
    
    context "Calling Speaker.to_csv" do
      setup do
        @csv = Speaker.to_csv
      end
    
      should "return a csv of speaker data" do
        assert !@csv.blank?
      end
    end
  end
  
  context "With a speaker that is not assigned to an event" do
    setup do
      @speaker = Factory(:speaker, :event_id => nil)
    end
    should "be a proposal" do
      assert @speaker.is_proposal?
    end
    
    should "not be able to assign it to an event owned by another ignite" do
      @speaker.event = Factory(:event)
      assert !@speaker.valid?
    end
  end
  
  context "A speaker that is assigned to an event" do
    setup do
      @event = Factory(:event)
      @speaker = Factory(:speaker, :event => @event, :ignite => @event.ignite)
    end
    should "not be a proposal" do
      assert !@speaker.is_proposal?
    end
  end
end
