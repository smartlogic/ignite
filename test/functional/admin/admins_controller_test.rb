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
  end
  
  # test "should get index" do
  #   log_in ggentzke do
  #     get :index
  #   end
  #   assert_response :success
  #   assert_not_nil assigns(:admins)
  # end
  # 
  # test "should get new" do
  #   log_in ggentzke do
  #     get :new
  #   end
  #   assert_response :success
  # end
  # 
  # test "should create admin" do
  #   assert_difference('Admin.count') do
  #     log_in ggentzke do
  #       post :create, :admin => { :login => "blahblah", :name => "blahblah", :password => "blahblah", :password_confirmation => "blahblah", :email => "blah@slsdev.net" }
  #     end
  #   end
  #   assert_redirected_to admin_admin_path(assigns(:admin))
  # end
  # 
  # test "should fail to create admin because of password mismatch" do
  #   assert_no_difference('Admin.count') do
  #     log_in ggentzke do
  #       post :create, :admin => { :login => "blahblah", :name => "blahblah", :password => "blahblah", :password_confirmation => "efefefef", :email => "blah@slsdev.net" }
  #     end
  #   end
  #   assert_template 'new'
  # end
  # 
  # test "should show admin" do
  #   log_in ggentzke do
  #     get :show, :id => pattichan.id
  #   end
  #   assert_response :success
  # end
  # 
  # test "should get edit" do
  #   log_in ggentzke do
  #     get :edit, :id => pattichan.id
  #   end
  #   assert_response :success
  # end
  # 
  # test "should update admin" do
  #   log_in ggentzke do
  #     put :update, :id => pattichan.id, :admin => { }
  #   end
  #   assert_redirected_to admin_admin_path(assigns(:admin))
  # end
  # 
  # test "should update admin and change password" do
  #   log_in ggentzke do
  #     put :update, :id => pattichan.id, :admin => { :password => "newpassword", :password_confirmation => "newpassword" }
  #   end
  #   assert Admin.authenticate(pattichan.login,"newpassword")
  #   assert_redirected_to admin_admin_path(assigns(:admin))
  # end
  # 
  # test "should update myself" do
  #   log_in ggentzke do
  #     put :update, :id => ggentzke.id, :admin => { :login => "new_login", :password => "new_password", :password_confirmation => "new_password" }
  #   end
  #   assert_redirected_to admin_admin_path(assigns(:admin))
  # end
  # 
  # test "should fail to update myself because of mismatched passwords" do
  #   log_in ggentzke do
  #     put :update, :id => ggentzke.id, :admin => { :login => "new_login", :password => "new_password", :password_confirmation => "bork" }
  #   end
  #   assert_template 'edit'
  # end
  # 
  # test "should destroy admin" do
  #   assert_difference('Admin.count', -1) do
  #     log_in ggentzke do
  #       delete :destroy, :id => pattichan.id
  #     end
  #   end
  # 
  #   assert_redirected_to admin_admins_path
  # end
end
