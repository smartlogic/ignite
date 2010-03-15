require File.dirname(__FILE__) + '/../../test_helper'

class Admin::CommentsControllerTest < ActionController::TestCase
  context 'With an admin logged in' do
    setup do
      @admin = Factory(:admin)
      @ignite = Factory(:ignite, :city => 'Baltimore', :domain => 'ignitebaltimore.localhost')
      set_host(@ignite)
      log_in @admin
    end
    
    context 'with 2 articles with 1 comment each' do
      setup do
        @article1 = Factory(:article, :ignite => @ignite)
        @article2 = Factory(:article, :ignite => @ignite)
        @a1_comment1 = Factory(:comment, :parent => @article1)
        @a1_comment2 = Factory(:comment, :parent => @article1)
        @a2_comment1 = Factory(:comment, :parent => @article2)
        @a2_comment2 = Factory(:comment, :parent => @article2)
      end
      
      context 'on GET to index' do 
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template 'index'
      end
      
      context 'on DELETE to destroy' do
        setup do
          delete :destroy, :id => @a1_comment1.id
        end
        should_redirect_to('comments index') { admin_comments_path }
        should_flash(:notice)
        should_change("number of comments", :by => -1) { @article1.comments.count }
      end
    end
  end
end
