require File.dirname(__FILE__) + '/../../test_helper'

class Admin::IgnitesControllerTest < ActionController::TestCase
  context 'With two ignites, each with their own admin, and one superadmin' do
    setup do
      @admin1 = Factory(:admin)
      @ignite1 = @admin1.ignite
      @admin2 = Factory(:admin)
      @ignite2 = @admin2.ignite
      @superadmin = Factory(:superadmin)
      set_host @ignite1
    end
    
    context 'when admin1 is logged in' do
      setup do
        log_in @admin1
      end
      
      context 'on GET to show for his own ignite' do
        setup do
          get :show, :id => @ignite1.id
        end
        should_respond_with :success
        should_render_template 'show'
      end
      
      context 'on GET to show for the other ignite' do
        setup do
          get :show, :id => @ignite2.id
        end
        should_respond_with 403
      end

      context 'on GET to edit for his own ignite' do
        setup do
          get :edit, :id => @ignite1.id
        end
        should_respond_with :success
        should_render_template 'edit'
      end
      
      context 'on GET to edit for the other ignite' do
        setup do
          get :edit, :id => @ignite2.id
        end
        should_respond_with 403
      end
      
      context 'on PUT to update for his own ignite that is successful' do
        setup do
          put :update, :id => @ignite1.id, :ignite => Factory.attributes_for(:ignite)
        end
        should_redirect_to("show") { admin_ignite_path(@ignite1) }
        should_flash(:notice)
      end
      
      context 'on PUT to update for his own ignite that fails' do
        setup do
          put :update, :id => @ignite1.id, :ignite => Factory.attributes_for(:ignite, :city => nil)
        end
        should_respond_with :success
        should_render_template 'edit'
      end
      
      context 'on PUT to update for the other ignite' do
        setup do
          put :update, :id => @ignite2.id
        end
        should_respond_with 403
      end
      
      context 'on GET to index' do
        setup do
          get :index
        end
        should_respond_with 403
      end
      
      context 'on GET to new' do
        setup do
          get :new
        end
        should_respond_with 403
      end
      
      context 'on POST to create' do
        setup do
          post :create
        end
        should_respond_with 403
      end
    end
    
    context 'when superadmin is logged in' do
      setup do
        log_in @superadmin
      end
      
      context 'on GET to index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template 'index'
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
          post :create, :ignite => Factory.attributes_for(:ignite)
        end
        should_redirect_to("ignite page") { admin_ignite_path(Ignite.last) }
        should_flash(:notice)
        should_change("number of ignites", :by => 1) { Ignite.count }
      end
      
      context 'on POST to create that fails' do
        setup do
          post :create, :ignite => Factory.attributes_for(:ignite, :city => nil)
        end
        should_respond_with :success
        should_render_template 'new'
        should_not_change("number of ignites") { Ignite.count }
      end
    end
  end
end
