require File.dirname(__FILE__) + '/../test_helper'

class EventsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert assigns(:events)
    assert_template 'index'
    assert_equal "Events", assigns(:page_title)
  end
  
  test "should get past events" do
    get :past
    assert_response :success
    assert_equal baltimore.events.past, assigns(:events)
    assert_template 'past'
    assert_equal "Past Events", assigns(:page_title)
  end

  test "should show current event" do
    get :show, :id => ignite2.id
    assert_response :success
    assert_equal ignite2, assigns(:event)
    assert_equal ignite2.speakers, assigns(:speakers)
    assert_equal ignite2.comments, assigns(:comments)
    assert_template 'show'
    assert_equal "#{ignite2.name} | Events", assigns(:page_title)
  end
  
  test "should show past event" do
    get :show, :id => ignite1.id
    assert_response :success
    assert_equal ignite1, assigns(:event)
    assert_template 'show'
    assert_equal "#{ignite1.name} | Events", assigns(:page_title)
  end
  
  test "should post comment to event" do
    exp_comments_cnt = ignite1.comments.size + 1
    assert_difference 'Comment.count' do
      post :post_comment, {:id => ignite1.id, :comment => {:author => "me", :email => "none", :url => "none", :content => "asdfasdfasdf"} }
    end
    assert_equal ignite1.comments(true).size, exp_comments_cnt
  end
  
  test "should fail to post comment because of no name" do
    exp_comments_cnt = ignite1.comments.size
    assert_no_difference 'Comment.count' do
      post :post_comment, {:id => ignite1.id, :comment => {} }
    end
    assert_equal ignite1.comments(true).size, exp_comments_cnt
  end

end