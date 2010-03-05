require File.dirname(__FILE__) + '/../../test_helper'

class Admin::SpeakersControllerTest < ActionController::TestCase
  test "should get index" do
    log_in ggentzke  do
      get :index
    end
    assert_response :success
    assert_not_nil assigns(:speakers)
  end

  test "should get new" do
    log_in(ggentzke) do
      get :new
    end
    assert_response :success
  end

  test "should create speaker" do
    assert_difference('Speaker.count') do
      log_in(ggentzke) do
        post :create, :speaker => { :ignite_id => baltimore.id, :name => "some unique name", :title => "i am a title", :description => "this is a desc", :bio => "born, grew up, lived", :email => "blah@slsdev.net" }
      end
    end

    assert_redirected_to admin_speaker_path(assigns(:speaker))
  end

  test "should show speaker" do
    log_in(ggentzke) do
      get :show, :id => brian.id
    end
    assert_response :success
  end

  test "should get edit" do
    log_in(ggentzke) do
      get :edit, :id => brian.id
    end
    assert_response :success
  end

  test "should update speaker with event" do
    assert_equal brian.event, ignite2
    log_in(ggentzke) do
      put :update, :id => brian.id, :speaker => {:event_id => ignite1.id }
    end
    assert_equal brian.reload.event, ignite1
    assert_redirected_to admin_speaker_path(assigns(:speaker))
  end

  test "should update speaker and unassign from event" do
    assert_equal brian.event, ignite2
    log_in(ggentzke) do
      put :update, :id => brian.id, :speaker => { }
    end
    assert_nil brian.reload.event
    assert_redirected_to admin_speaker_path(assigns(:speaker))
  end

  test "should destroy speaker with dependent comments" do
    assert chris.comments.size > 0
    exp_comment_cnt = Comment.count - chris.comments.size
    assert_difference('Speaker.count', -1) do
      log_in(ggentzke) do
        delete :destroy, :id => chris.id
      end
    end
    assert_equal exp_comment_cnt, Comment.count
    assert_redirected_to admin_speakers_path
  end
end
