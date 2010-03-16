require File.dirname(__FILE__) + '/../../test_helper'

class Admin::ArticlesControllerTest < ActionController::TestCase
  context 'With an admin logged in' do
    setup do
      @admin = Factory(:admin)
      @ignite = Factory(:ignite, :city => 'Baltimore', :domain => 'ignitebaltimore.localhost')
      set_host(@ignite)
      log_in @admin
    end
    
    context 'with 2 articles' do
      setup do
        @article1 = Factory(:article, :ignite => @ignite)
        @article2 = Factory(:article, :ignite => @ignite)
      end
      
      context 'on GET to index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template 'index'
        should "return 2 articles" do
          assert_equal 2, assigns(:articles).size
        end
      end
      
      context 'on GET to show' do
        setup do
          get :show, :id => @article1.id
        end
        should_respond_with :success
        should_render_template 'show'
      end
      
      context 'on GET to edit' do
        setup do
          get :edit, :id => @article1.id
        end
        should_respond_with :success
        should_render_template 'edit'
      end
      
      context 'on PUT to update' do
        setup do
          put :update, :id => @article1.id, :article => Factory(:attrs_for_article)
        end
        should_redirect_to('article path') { admin_article_path(@article1.reload) }
        should_flash(:notice)
      end
      
      context 'on DELETE to destroy' do
        setup do
          delete :destroy, :id => @article1.id
        end
        should_redirect_to('articles index') { admin_articles_path }
        should_flash(:notice)
      end
    end
    
    context 'on GET to new' do
      setup do
        get :new
      end
      should_respond_with :success
      should_render_template 'new'
    end
    
    context 'on POST to create that is successful' do
      setup do
        post :create, :article => Factory.attributes_for(:article, :ignite => nil)
      end
      should_redirect_to('article path') { admin_article_path(Article.last) }
      should_flash(:notice)
      should_change('number of articles') { @ignite.articles.count }
    end
  end
end
