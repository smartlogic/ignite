require File.dirname(__FILE__) + '/../test_helper'

class OrganizersControllerTest < ActionController::TestCase
  context 'a public visitor to the site with two organizers' do
    setup do
      @ignite = Factory(:ignite)
      set_host @ignite
      @organizer1 = Factory(:organizer, :ignite => @ignite)
      Factory(:organizer, :ignite => @ignite)
    end
    
    context 'on GET to index' do
      setup do
        get :index
      end
      should_respond_with :success
      should_render_template 'index'
      should "Set title" do
        assert_equal "Organizers", assigns(:page_title)
      end
    end
    
    context 'on GET to show' do
      setup do
        get :show, :id => @organizer1.id
      end
      should_respond_with :success
      should_render_template 'show'
    end
  end
end