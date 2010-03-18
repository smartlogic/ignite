require File.dirname(__FILE__) + '/../test_helper'

class SpeakerTest < ActiveSupport::TestCase
  context "With a saved speaker" do
    setup do
      @speaker = Factory(:speaker)
    end
    subject { @speaker }
    should_validate_presence_of :name, :title, :description, :bio, :event_id
    
    context 'with a comment' do
      setup do
        Factory(:comment, :parent => @speaker)
      end
      
      context 'on destroy' do
        setup do
          @speaker.destroy
        end
        should_change("number of speakers", :by => -1) { Speaker.count }
        should_change("number of comments", :by => -1) { Comment.count }
      end
    end
  end
  
  context 'With a new speaker' do
    setup do
      @speaker = Speaker.new
    end
    should "begin in the proposal state" do
      assert @speaker.proposal?
    end
  end
end
