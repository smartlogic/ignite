require File.dirname(__FILE__) + '/../../test_helper'

class Admin::CommentsControllerTest < ActionController::TestCase
  test "should get index" do
    log_in(ggentzke) do
      get :index
    end
    assert_response :success
    assert_not_nil assigns(:comments)
  end

  test "should destroy comment" do
    assert_difference('Comment.count', -1) do
      log_in(ggentzke) do
        delete :destroy, :id => news_comment.id
      end
    end

    assert_redirected_to admin_comments_path
  end
end
