require File.dirname(__FILE__) + '/../../test_helper'

class Admin::ArticlesControllerTest < ActionController::TestCase
  test "should get index" do
    log_in ggentzke do
      get :index
    end
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  test "should get new" do
    log_in ggentzke do
      get :new
    end
    assert_response :success
  end

  test "should create article" do
    assert_difference('Article.count') do
      log_in ggentzke do
        post :create, :article => { }
      end
    end

    assert_redirected_to admin_article_path(assigns(:article))
  end

  test "should show article" do
    log_in ggentzke do
      get :show, :id => regular_article.id
    end
    assert_response :success
  end

  test "should get edit" do
    log_in ggentzke do
      get :edit, :id => regular_article.id
    end
    assert_response :success
  end

  test "should update article" do
    log_in ggentzke do
      put :update, :id => regular_article.id, :article => { }
    end
    assert_redirected_to admin_article_path(assigns(:article))
  end

  test "should destroy article" do
    assert_difference('Article.count', -1) do
      log_in ggentzke do
        delete :destroy, :id => news_article.id
      end
    end

    assert_redirected_to admin_articles_path
  end
end
