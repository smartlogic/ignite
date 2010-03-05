require File.dirname(__FILE__) + '/../test_helper'
require 'sessions_controller'

# Re-raise errors caught by the controller.
class SessionsController; def rescue_action(e) raise e end; end

class SessionsControllerTest < ActionController::TestCase

  def test_should_login_and_redirect
    post :create, :login => 'ggentzke', :password => 'ggentzke'
    assert session[:admin_id]
    assert_response :redirect
  end

  def test_should_fail_login_and_not_redirect
    post :create, :login => 'ggentzke', :password => 'bad password'
    assert_nil session[:admin_id]
    assert_response :success
  end

  def test_should_logout
    log_in ggentzke do
      get :destroy
    end
    assert_nil session[:admin_id]
    assert_response :redirect
  end

  def test_should_not_remember_me
    @request.cookies["auth_token"] = nil
    post :create, :login => 'ggentzke', :password => 'ggentzke'
    puts @response.cookies["auth_token"]
    assert @response.cookies["auth_token"].blank?
  end
  
  def test_should_delete_token_on_logout
    log_in ggentzke do
      get :destroy
    end
    assert @response.cookies["auth_token"].blank?
  end

  protected
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    
    def cookie_for(admin)
      auth_token admins(admin).remember_token
    end
end
