require File.dirname(__FILE__) + '/../test_helper'

class SpeakerTest < ActiveSupport::TestCase
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
  
  context "A speaker that is not assigned to an event" do
    setup do
      @speaker = Factory(:speaker, :event_id => nil)
    end
    should "be a proposal" do
      assert @speaker.is_proposal?
    end
  end
  
  context "A speaker that is assigned to an event" do
    setup do
      @speaker = Factory(:speaker, :event => Factory(:event))
    end
    should "not be a proposal" do
      assert !@speaker.is_proposal?
    end
  end
end
