require File.dirname(__FILE__) + '/../test_helper'

class ArticlesControllerTest < ActionController::TestCase
  context "A public visitor to Ignite Baltimore" do
    setup do
      @ignite = Factory(:ignite, :city => 'Baltimore', :domain => 'ignitebaltimore.localhost')
      set_host(@ignite)
    end
    
    should "render RSVP link in layout when an RSVP URL has been provided, on GET to index" do
      @ignite.featured_event.update_attributes!(:rsvp_url => 'http://www.google.com')
      get :index
      assert_select '#location .links a', :text => 'RSVP', :count => 1
    end
    
    should "not render RSVP link in layout when an RSVP URL has not been provided, on GET to index" do
      get :index
      assert_select '#location .links a', :text => 'RSVP', :count => 0
    end
    
    context "with an article that has set :show_in_navigation, on GET to index" do
      setup do
        @name = 'Article that will show up'
        @ignite.articles.create!(:name => @name, :show_in_navigation => true)
        get :index
      end
      should 'display article in navigation' do
        assert_select '#nav a', :text => @name, :count => 1
      end
    end
    
    context 'with an article that has not set :show_in_navigation, on GET to index' do
      setup do
        @name = 'Article that will not show up'
        @ignite.articles.create!(:name => @name)
        get :index
      end
      should 'not display article in navigation' do
        assert_select '#nav a', :text => @name, :count => 0
      end
    end
    
    context 'With two news articles and a regular article' do
      setup do
        @newsone = @ignite.articles.create!(:name => 'News Article', :is_news => true)
        @newstwo = @ignite.articles.create!(:name => 'News Article', :is_news => true, :comments_allowed => false)
        @nonnews = @ignite.articles.create!(:name => 'Nonnews Article', :is_news => false)
      end
      context 'on GET to top_news' do
        setup do
          get :top_news
        end
        should_respond_with :success
        should_render_template 'show'
      end
      context 'on GET to news' do
        setup do
          get :news
        end
        should_respond_with :success
        should_render_template 'index'
        should "show 2 articles" do
          assert_equal 2, assigns(:articles).size
        end
      end
      context 'on GET to index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template 'index'
        should "show 3 articles" do
          assert_equal 3, assigns(:articles).size
        end
      end
      context 'on GET to show' do
        setup do
          get :show, :id => @newsone.id
        end
        should_respond_with :success
        should_render_template 'show'
      end
      
      context 'on POST to post_comment that is successful' do
        setup do
          post :post_comment, :id => @newsone.id, :comment => Factory.attributes_for(:comment)
          @newsone.reload
        end
        should_redirect_to("article path") { article_path(@newsone) }
        should_flash(:notice)
        should_change("number of comments", :by => 1) { @newsone.comments.size }
      end
      
      context 'on POST to post_comment that fails' do
        setup do
          post :post_comment, :id => @newsone.id, :comment => Factory.attributes_for(:comment, :author => nil)
        end
        should_respond_with :success
        should_render_template 'show'
        should_not_change("number of comments") { @newsone.comments.size }        
      end
      
      context 'on POST to post_comment that fails because it\'s not accepting comments' do
        setup do
          post :post_comment, :id => @newstwo.id, :comment => Factory.attributes_for(:comment)
        end
        should_redirect_to("article path") { article_path(@newstwo) }
        should_flash(:error)
        should_not_change("number of comments") { @newstwo.comments.size }
      end
    end
  end
end