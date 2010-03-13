require File.dirname(__FILE__) + '/../test_helper'

class OrganizersControllerTest < ActionController::TestCase
  context 'a public visitor to the site with two organizers' do
    setup do
      @ignite = Factory(:ignite)
      set_host @ignite
      @organizer1 = Factory(:organizer, :ignite => @ignite)
      @organizer2 = Factory(:organizer, :ignite => @ignite)
      @ignite.featured_event.organizers << @organizer1 << @organizer2
    end
    
    context 'on GET to index' do
      setup do
        get :index
      end
      should_respond_with :success
      should_render_template 'index'
      should "Set title" do
        assert_equal "Organizers | #{@ignite.featured_event.name}", assigns(:page_title)
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