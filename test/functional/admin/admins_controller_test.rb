require File.dirname(__FILE__) + '/../../test_helper'

class Admin::AdminsControllerTest < ActionController::TestCase
  context "With an ignite and an admin," do
    setup do 
      @ignite = Factory(:ignite)
      @admin = Factory(:admin, :ignite => @ignite)
      set_host @ignite
    end
    
    context "with two superadmins, another admin for the same ignite, and an admin for a different ignite" do
      setup do
        @superadmin1 = Factory(:superadmin)
        @superadmin2 = Factory(:superadmin)
        @other_admin = Factory(:admin, :ignite => @ignite)
        Factory(:admin)
      end
      
      context ", when a regular admin is logged in" do
        setup do
          log_in @admin
        end

        context "on GET to index" do
          setup do
            get :index
          end
          should_respond_with :success
          should_render_template 'index'
          should "find 4 admins, the 2 superadmins, the logged in admin, and the other admin" do
            assert_equal 4, assigns(:admins).size
            assert [@admin, @superadmin1, @superadmin2, @other_admin].all?{|admin| assigns(:admins).include?(admin)}
          end
          should "render edit links for the two regular admins" do
            assert_select '.adminTable a', :text => 'Edit', :count => 2
          end
          should "render remove link for only the other regular admin" do
            assert_select '.adminTable a', :text => 'Remove', :count => 1
          end
        end
      end
      
      context ", when a superadmin is logged in" do
        setup do
          log_in @superadmin1
        end
        
        context "on GET to index" do
          setup do
            get :index
          end
          should_respond_with :success
          should_render_template 'index'
          should "render edit links for all four admins" do
            assert_select '.adminTable a', :text => 'Edit', :count => 4
          end
          should "render remove links for all three other admins" do
            assert_select '.adminTable a', :text => 'Remove', :count => 3          
          end
        end
      end
    end
  end
  
  context 'With an admin logged in' do
    setup do
      @ignite = Factory(:ignite)
      @admin = Factory(:admin, :ignite => @ignite)
      set_host @ignite
      log_in @admin
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
        post :create, :admin => Factory.attributes_for(:admin, :ignite => nil)
      end
      should_redirect_to("index") { admin_admins_path }
      should_flash(:notice)
      should_change("number of admins", :by => 1) { @ignite.admins.count }
    end
    
    context 'on POST to create that fails' do
      setup do
        post :create, :admin => Factory.attributes_for(:admin, :login => nil)
      end
      should_respond_with :success
      should_render_template 'new'
      should_not_change("number of admins") { @ignite.admins.count }
    end
    
    context 'on GET to edit' do
      setup do
        get :edit, :id => @admin.id
      end
      should_respond_with :success
      should_render_template 'edit'
    end
    
    context 'on PUT to update that is successful' do
      setup do
        put :update, :id => @admin.id, :admin => Factory.attributes_for(:admin, :ignite => nil)
      end
      should_redirect_to("index") { admin_admins_path }
      should_flash(:notice)
    end
    
    context 'on PUT to update that fails' do
      setup do
        put :update, :id => @admin.id, :admin => Factory.attributes_for(:admin, :login => nil)
      end
      should_respond_with :success
      should_render_template 'edit'
    end
    
    context 'with a second admin' do
      setup do
        @another_admin = Factory(:admin, :ignite => @ignite)
      end
      context 'on DELETE to destroy' do
        setup do
          delete :destroy, :id => @another_admin.id
        end
        should_redirect_to('index') { admin_admins_path }
        should_flash(:notice)
        should_change("number of admins", :by => -1) { @ignite.admins.count }
      end
    end
    
    context 'on DELETE to destroy for yourself' do
      setup do
        delete :destroy, :id => @admin.id
      end
      should_not_change('number of admins') { @ignite.admins.count }
    end
  end
end
