require File.dirname(__FILE__) + '/../test_helper'

class SpeakerTest < ActiveSupport::TestCase
  context "With a saved speaker" do
    setup do
      @speaker = Factory(:speaker)
    end
    subject { @speaker }
    should_validate_presence_of :name, :title, :description, :bio, :event_id
  end
  
  context 'With a new speaker' do
    setup do
      @speaker = Speaker.new
    end
    should "begin in the proposal state" do
      assert @speaker.proposal?
    end
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
end
