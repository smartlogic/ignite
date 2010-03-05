require File.dirname(__FILE__) + '/../../test_helper'

class Admin::AdminsControllerTest < ActionController::TestCase
  test "should get index" do
    log_in ggentzke do
      get :index
    end
    assert_response :success
    assert_not_nil assigns(:admins)
  end

  test "should get new" do
    log_in ggentzke do
      get :new
    end
    assert_response :success
  end

  test "should create admin" do
    assert_difference('Admin.count') do
      log_in ggentzke do
        post :create, :admin => { :login => "blahblah", :name => "blahblah", :password => "blahblah", :password_confirmation => "blahblah", :email => "blah@slsdev.net" }
      end
    end
    assert_redirected_to admin_admin_path(assigns(:admin))
  end

  test "should fail to create admin because of password mismatch" do
    assert_no_difference('Admin.count') do
      log_in ggentzke do
        post :create, :admin => { :login => "blahblah", :name => "blahblah", :password => "blahblah", :password_confirmation => "efefefef", :email => "blah@slsdev.net" }
      end
    end
    assert_template 'new'
  end

  test "should show admin" do
    log_in ggentzke do
      get :show, :id => pattichan.id
    end
    assert_response :success
  end

  test "should get edit" do
    log_in ggentzke do
      get :edit, :id => pattichan.id
    end
    assert_response :success
  end

  test "should update admin" do
    log_in ggentzke do
      put :update, :id => pattichan.id, :admin => { }
    end
    assert_redirected_to admin_admin_path(assigns(:admin))
  end

  test "should update admin and change password" do
    log_in ggentzke do
      put :update, :id => pattichan.id, :admin => { :password => "newpassword", :password_confirmation => "newpassword" }
    end
    assert Admin.authenticate(pattichan.login,"newpassword")
    assert_redirected_to admin_admin_path(assigns(:admin))
  end

  test "should update myself" do
    log_in ggentzke do
      put :update, :id => ggentzke.id, :admin => { :login => "new_login", :password => "new_password", :password_confirmation => "new_password" }
    end
    assert_redirected_to admin_admin_path(assigns(:admin))
  end

  test "should fail to update myself because of mismatched passwords" do
    log_in ggentzke do
      put :update, :id => ggentzke.id, :admin => { :login => "new_login", :password => "new_password", :password_confirmation => "bork" }
    end
    assert_template 'edit'
  end

  test "should destroy admin" do
    assert_difference('Admin.count', -1) do
      log_in ggentzke do
        delete :destroy, :id => pattichan.id
      end
    end

    assert_redirected_to admin_admins_path
  end
end
