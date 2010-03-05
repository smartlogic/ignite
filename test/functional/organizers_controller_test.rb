require File.dirname(__FILE__) + '/../test_helper'

class OrganizersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_equal "Organizers", assigns(:page_title)
    assert_response :success
    assert assigns(:founders)
    assert assigns(:guests)
    assert_template 'index'
  end

  test "should show organizer" do
    get :show, :id => david.id
    assert_response :success
    assert_equal "#{david.name} | Organizers", assigns(:page_title)
    assert_template 'show'
  end

end