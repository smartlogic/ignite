require File.dirname(__FILE__) + '/../test_helper'

class BaseUserController < ApplicationController
  def mock_action
    render :nothing => true
  end
end

ActionController::Routing::Routes.draw do |map|
  map.mock_action '/mock_action', :controller => 'base_user', :action => 'mock_action'
end

class BaseUserControllerTest < ActionController::TestCase
  context "With Baltimore and DC Ignites" do
    setup do
      @baltimore = Factory(:ignite, :city => 'Baltimore', :domain => 'ignitebaltimore.com')
      @dc        = Factory(:ignite, :city => 'DC', :domain => 'ignite-dc.com')
    end
    
    context "When accessing a public page with baltimore's subdomain" do
      setup do
        set_host(@baltimore)
        get :mock_action
      end
    
      should_respond_with :success
      should "load baltimore" do
        assert_equal @baltimore.id, assigns(:ignite).id
      end
    end
  
    context "When accessing a public page with baltimore's subdomain prefixed with www" do
      setup do
        set_host("www.#{@baltimore.domain}.com")
        get :mock_action
      end
    
      should_respond_with :success
      should "load baltimore" do
        assert_equal @baltimore.id, assigns(:ignite).id
      end    
    end
  
    context "When accessing a public page with dc's subdomain" do
      setup do
        set_host(@dc)
        get :mock_action
      end
    
      should_respond_with :success
      should "load baltimore" do
        assert_equal @dc.id, assigns(:ignite).id
      end
    end
  
    context "When accessing a public site with an invalid subdomain" do
      setup do
        @request.host = 'somethingwedonthave.com'
        get :mock_action
      end
    
      should_respond_with 404
    end
  end
end