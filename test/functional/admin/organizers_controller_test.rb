require File.dirname(__FILE__) + '/../../test_helper'

class Admin::OrganizersControllerTest < ActionController::TestCase
  context 'With an admin logged in' do
    setup do
      @ignite = Factory(:ignite)
      @admin = Factory(:admin, :ignite => @ignite)
      set_host @ignite
      log_in @admin
    end
    
    context 'with an organizer' do
      setup do
        @organizer = Factory(:organizer, :ignite => @ignite)
      end
    
      context 'on GET to index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template 'index'
      end
      
      context 'on GET to show' do
        setup do
          get :show, :id => @organizer.id
        end
        should_respond_with :success
        should_render_template 'show'
      end
      
      context 'on GET to edit' do
        setup do
          get :edit, :id => @organizer.id
        end
        should_respond_with :success
        should_render_template 'edit'
      end
      
      context 'on PUT to update that is successful' do
        setup do
          put :update, :id => @organizer.id, :organizer => Factory.attributes_for(:organizer)\
        end
        should_redirect_to('show') { admin_organizer_path(@organizer) }
        should_flash(:notice)
      end
      
      context 'on PUT to update that fails' do
        setup do
          put :update, :id => @organizer.id, :organizer => Factory.attributes_for(:organizer, :name => false)
        end
        should_respond_with :success
        should_render_template 'edit'
      end
      
      context 'on DELETE to destroy' do
        setup do
          delete :destroy, :id => @organizer.id
        end
        should_redirect_to('index') { admin_organizers_path }
        should_flash(:notice)
      end
    end
    
    context 'on GET to index without any organizers' do
      setup do
        get :index
      end
      should_respond_with :success
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
        post :create, :organizer => Factory.attributes_for(:organizer)
      end
      should_redirect_to('show') { admin_organizer_path(Organizer.last) }
      should_flash(:notice)
      should_change('number of organizers', :by => 1) { @ignite.organizers.count }
    end
    
    context 'on POST to create that fails' do
      setup do
        post :create, :organizer => Factory.attributes_for(:organizer, :name => nil)
      end
      should_respond_with :success
      should_render_template 'new'
      should_not_change('number of organizers') { @ignite.organizers.count }
    end
    
    should "be able to assign organizers to events"
  end
end
