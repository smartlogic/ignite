require File.dirname(__FILE__) + '/../test_helper'

class ProposalsControllerTest < ActionController::TestCase
  context "A public visitor" do
    should "view proposals" do
      get :index
      assert_response :success
      assert_equal "Proposals", assigns(:page_title)
      assert_equal assigns(:proposals).all?(&:is_proposal?)
      assert_template 'proposals'
    end
  end


  test "should get new" do
    get :new
    assert_response :success
    assert_template 'new'
    assert_equal "Submit a Proposal", assigns(:page_title)
  end

  test "should create proposal" do
    assert_difference('Speaker.count') do
      post :create, :speaker => {:name => "some unique name", :title => "i am a title", :description => "this is a desc",
                                 :bio => "born, grew up, lived", :email => "blah@slsdev.net" }
    end
    assert_redirected_to article_path(submission_article)
  end

  test "should show proposal" do
    get :show, :id => proposal.id
    assert_response :success
    assert_equal assigns(:proposal), proposal
    assert_equal proposal.comments, assigns(:comments)
    assert assigns(:captcha)
    assert_template 'show'
    assert_equal "#{proposal.name} | Proposals", assigns(:page_title)
  end
  
  test "should post comment to proposal" do
    exp_comments_cnt = proposal.comments.size + 1
    assert_difference 'Comment.count' do
      post :post_comment, {:id => proposal.id, :comment => {:author => "me", :email => "none", :url => "none", :content => "asdfasdfasdf"} }
    end
    assert_equal proposal.comments(true).size, exp_comments_cnt
    assert_redirected_to proposal_path(proposal)
  end
  
  test "should fail to post comment because of no name" do
    exp_comments_cnt = proposal.comments.size
    assert_no_difference 'Comment.count' do
      post :post_comment, {:id => proposal.id, :comment => {} }
    end
    assert_equal proposal.comments(true).size, exp_comments_cnt
    assert_template 'show'
  end

end
