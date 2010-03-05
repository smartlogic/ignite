require File.dirname(__FILE__) + '/../../test_helper'

class Admin::OrganizerRolesControllerTest < ActionController::TestCase
  test "should get index" do
    log_in(ggentzke) do
      get :index
    end
    assert_response :success
    assert_not_nil assigns(:organizer_roles)
  end

  test "should get new" do
    log_in(ggentzke) do
      get :new
    end
    assert_response :success
  end

  test "should create organizer_role" do
    assert_difference('OrganizerRole.count') do
      log_in(ggentzke) do
        post :create, :organizer_role => { :title => "a new role" }
      end
    end

    assert_redirected_to admin_organizer_role_path(assigns(:organizer_role))
  end

  test "should show organizer_role" do
    log_in(ggentzke) do
      get :show, :id => founder.id
    end
    assert_response :success
  end

  test "should get edit" do
    log_in(ggentzke) do
      get :edit, :id => founder.id
    end
    assert_response :success
  end

  test "should update organizer_role" do
    log_in(ggentzke) do
      put :update, :id => founder.id, :organizer_role => { }
    end
    assert_redirected_to admin_organizer_role_path(assigns(:organizer_role))
  end

  test "should destroy organizer_role" do
    assert_difference('OrganizerRole.count', -1) do
      log_in(ggentzke) do
        delete :destroy, :id => founder.id
      end
    end

    assert_redirected_to admin_organizer_roles_path
  end
end
