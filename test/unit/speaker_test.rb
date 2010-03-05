require File.dirname(__FILE__) + '/../test_helper'

class SpeakerTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "should destroy dependent comments" do
    assert proposal.comments.size > 0
    exp_comment_cnt = Comment.count - proposal.comments.size
    assert_difference 'Speaker.count', -1 do
      proposal.destroy
    end
    assert_equal exp_comment_cnt, Comment.count
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
