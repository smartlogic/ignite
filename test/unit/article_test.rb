require File.dirname(__FILE__) + '/../test_helper'

class ArticleTest < ActiveSupport::TestCase
  context 'An unsaved new article' do
    setup do
      @article = Article.new
    end
    should 'default to non-news' do
      assert !@article.is_news?
    end
    should 'default to non-sticky' do
      assert !@article.is_sticky?
    end
    should 'default to commentable' do
      assert @article.comments_allowed?
    end
  end
  
  context 'A saved article' do
    setup do
      @article = Factory(:article)
    end
    subject { @article }
    should_validate_presence_of :ignite_id, :name
  end
  
  context 'A saved sticky article' do
    setup do
      @article = Factory(:article, :is_sticky => true)
    end
    context 'when creating a new article that is sticky' do
      setup do
        @new_article = Factory(:article, :ignite => @article.ignite, :is_sticky => true)
      end
      should "make the new article sticky" do
        assert @new_article.reload.is_sticky?
      end
      should "make unsticky the old article" do
        assert !@article.reload.is_sticky?
      end
    end
  end
end
