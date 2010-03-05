require File.dirname(__FILE__) + '/../../test_helper'

class Admin::EventsControllerTest < ActionController::TestCase

  test "should get index" do
    log_in ggentzke  do
      get :index
    end
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test "should get new" do
    log_in(ggentzke) do
      get :new
    end
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      log_in(ggentzke) do
        post :create, :event => { :name => "some unique name", :description => "this is a desc", :date => DateTime.parse("2/5/2009")}
      end
    end

    assert_redirected_to admin_event_path(assigns(:event))
  end

  test "should show event" do
    log_in(ggentzke) do
      get :show, :id => ignite2.id
    end
    assert_response :success
  end

  test "should get edit" do
    log_in(ggentzke) do
      get :edit, :id => ignite2.id
    end
    assert_response :success
  end

  test "should update event" do
    log_in(ggentzke) do
      put :update, :id => ignite2.id, :event => { }
    end
    assert_redirected_to admin_event_path(assigns(:event))
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      log_in(ggentzke) do
        delete :destroy, :id => ignite2.id
      end
    end

    assert_redirected_to admin_events_path
  end
  
  test "should make an event featured and mark others as not featured" do
    assert_equal baltimore.featured_event, ignite2
    assert !ignite1.is_featured?
    
    log_in(ggentzke) do
      put :set_feature, :id => ignite1.id
    end
    assert_equal baltimore.featured_event, ignite1
    assert !ignite2.reload.is_featured?
    assert_redirected_to admin_events_url
  end
  
end