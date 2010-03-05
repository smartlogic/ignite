require File.dirname(__FILE__) + '/../../test_helper'

class Admin::OrganizersControllerTest < ActionController::TestCase
  test "should get index" do
    log_in(ggentzke) do
      get :index
    end
    assert_response :success
    assert_not_nil assigns(:organizers)
  end

  test "should get new" do
    log_in(ggentzke) do
      get :new
    end
    assert_response :success
  end

  test "should create organizer" do
    assert_difference('Organizer.count') do
      log_in(ggentzke) do
        post :create, :organizer => {:ignite => baltimore}
      end
    end

    assert_redirected_to admin_organizer_path(assigns(:organizer))
  end

  test "should show organizer" do
    log_in(ggentzke) do
      get :show, :id => david.id
    end
    assert_response :success
  end

  test "should get edit" do
    log_in(ggentzke) do
      get :edit, :id => david.id
    end
    assert_response :success
  end

  test "should update organizer" do
    log_in(ggentzke) do
      put :update, :id => david.id, :organizer => { }
    end
    assert_redirected_to admin_organizer_path(assigns(:organizer))
  end

  test "should destroy organizer" do
    assert_difference('Organizer.count', -1) do
      log_in(ggentzke) do
        delete :destroy, :id => david.id
      end
    end

    assert_redirected_to admin_organizers_path
  end
end
