require File.dirname(__FILE__) + '/../test_helper'

class SpeakersControllerTest < ActionController::TestCase
  test "should get default index" do
    get :index
    assert_response :success
    assert_equal Speaker.paginate(:all, :conditions => "aasm_state = 'active' AND event_id IS NOT NULL", :order => :name, :page => 1, :per_page => 16), assigns(:speakers)
    assert_equal Speaker.find(:all, :conditions => {:aasm_state => "active", :event_id => baltimore.featured_event.id}), assigns(:widget_speakers)
    assert_not_nil assigns(:selected_speaker)
    assert_equal baltimore.featured_event, assigns(:event)
    
    ws = assigns(:widget_speakers)
    if ws.size > 2
      assert assigns(:left).size >= (ws.size/2)
      assert assigns(:right).size >= (ws.size/2).floor
    end
    assert_template 'index'
  end
  
  test "should get index for ignite 1" do
    get :index, {:event_id => ignite1.id}
    assert_response :success
    assert_equal Speaker.find(:all, :conditions => {:aasm_state => "active", :event_id => ignite1.id}), assigns(:widget_speakers)
    assert_equal ignite1, assigns(:event)
    assert_template 'index'
  end

  test "should show speaker" do
    get :show, :id => brian.id
    assert_response :success
    assert_template 'show'
  end
  
  test "should post comment to speaker" do
    exp_comments_cnt = brian.comments.size + 1
    assert_difference 'Comment.count' do
      post :post_comment, {:id => brian.id, :comment => {:author => "me", :email => "none", :url => "none", :content => "asdfasdfasdf"} }
    end
    assert_equal brian.comments(true).size, exp_comments_cnt
    assert_redirected_to speaker_url(brian)
  end
  
  test "should fail to post comment because of no name" do
    exp_comments_cnt = brian.comments.size
    assert_no_difference 'Comment.count' do
      post :post_comment, {:id => brian.id, :comment => {} }
    end
    assert_equal brian.comments(true).size, exp_comments_cnt
    assert_template 'show'
  end

end
