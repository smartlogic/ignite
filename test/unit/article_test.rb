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
      @article = Factory.build(:article)
      @article.ignite = Factory(:ignite)
      @article.save!
    end
    subject { @article }
    should_validate_presence_of :ignite_id, :name
  end
end
