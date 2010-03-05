require File.dirname(__FILE__) + '/../test_helper'

class ArticlesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_equal Article.all, assigns(:articles)
    assert_template 'index'
  end

  test "should get friends" do
    get :friends
    assert_response :success
    assert_equal Article.find_by_name("Affiliates"), assigns(:article)
    assert_template 'articles/static'
    assert_equal "Friends", assigns(:page_title)
  end

  test "should get sponsor_ignite" do
    get :sponsor_ignite
    assert_response :success
    assert_equal Article.find_by_name("Sponsor Ignite"), assigns(:article)
    assert_template 'articles/static'
    assert_equal "Sponsor Ignite", assigns(:page_title)
  end
  
  test "should get about" do
    get :about
    assert_response :success
    assert_equal Article.find_by_name("About"), assigns(:article)
    assert_template 'articles/static'
    assert_equal "About", assigns(:page_title)
  end

  test "should get news" do
    get :news
    assert_response :success
    assert_equal Article.find(:all, :conditions => {:is_news => true}), assigns(:articles)
    assert_template 'index'
    assert_equal "News", assigns(:page_title)
  end

  test "should show article" do
    get :show, :id => news_article.id
    assert_response :success
  end
  
  test "should show article with comments" do
    get :show, :id => news_article.id
    assert_response :success
    assert news_article.comments_allowed?
    
  end
  
  test "should show article without comments" do
    get :show, :id => news_article_no_comments.id
    assert_response :success
    assert !news_article_no_comments.comments_allowed?
    
  end
  
  test "should post comment to article" do
    art = Article.find(:first, :conditions => {:comments_allowed => true})
    exp_comments_cnt = art.comments.size + 1
    assert_difference 'Comment.count' do
      post :post_comment, {:id => art.id, :comment => {:author => "me", :email => "none", :url => "none", :content => "asdfasdfasdf"} }
    end
    assert_equal art.comments(true).size, exp_comments_cnt
  end
  
  test "should fail to post comment because of no name" do
    art = Article.find(:first, :conditions => {:comments_allowed => true})
    exp_comments_cnt = art.comments.size
    assert_no_difference 'Comment.count' do
      post :post_comment, {:id => art.id, :comment => {} }
    end
    assert_equal art.comments(true).size, exp_comments_cnt
  end

end