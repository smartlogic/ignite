require File.dirname(__FILE__) + '/../../test_helper'

class Admin::EventsControllerTest < ActionController::TestCase
  context "An admin is logged into Ignite Baltimore" do
    setup do
      @admin = Factory(:admin)
      @baltimore = Factory(:ignite, :city => 'Baltimore', :domain => 'ignitebaltimore.localhost')
      @event = @baltimore.featured_event
      set_host(@baltimore)
      log_in @admin
    end
    
    context "with 2 Baltimore events and 1 DC event" do
      setup do
        @dc = Factory(:ignite, :city => 'DC')
        Factory(:event, :ignite => @baltimore, :date => Date.today + 60)
      end

      context "on GET to index" do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template 'index'
        should "only load baltimore events" do
          assert_equal 2, assigns(:events).size
          assert assigns(:events).all? {|evt| evt.ignite == @baltimore}
        end
      end
    end

    context "on GET to new" do
      setup do
        get :new
      end
      should_respond_with :success
      should_render_template 'new'
    end
  
    context "on POST to create that is successful" do
      setup do
        post :create, :event => Factory.attributes_for(:event, :ignite => nil)
      end
      should_redirect_to("event path") { admin_event_path(assigns(:event)) }
      should_flash(:notice)
      should_change("number of events", :by => 1) { @baltimore.events.count }
    end
    
    context "on POST to create that fails" do
      # nothing should make it fail yet
    end
  
    context "on GET to show" do
      setup do
        get :show, :id => @event.id
      end
      should_respond_with :success
      should_render_template 'show'
    end

    context "on GET to edit" do
      setup do
        get :edit, :id => @event.id
      end
      should_respond_with :success
      should_render_template 'edit'
    end
  
    context "on PUT to update that is successful" do
      setup do
        put :update, :id => @event.id, :event => Factory.attributes_for(:event, :ignite => nil)
      end
      should_redirect_to("event path") { admin_event_path(@event) }
      should_flash(:notice)
    end
  
    context "on PUT to update that fails" do
      # nothing will make it fail right now
      # setup do
      #   put :update, :id => @event.id, :event => Factory.attributes_for(:event, :ignite => nil, :name => nil)
      # end
      # should_respond_with :success
      # should_render_template 'edit'
    end
  
    context "on DELETE to destroy that is successful" do
      setup do
        @second_event = Factory(:event, :ignite => @event.ignite)
        delete :destroy, :id => @event.id
      end
      should_redirect_to("events path") { admin_events_path }
      should_flash(:notice)
    end
  
    context "on DELETE to destroy that fails" do
      setup do
        delete :destroy, :id => @event.id
      end
      should_redirect_to("events path") { admin_events_path }
      should_flash(:error)
    end
  
    context "on PUT to set_feature" do
      setup do
        @unfeatured_event = Factory(:event, :ignite => @event.ignite)
        put :set_feature, :id => @unfeatured_event.id
      end
      should_redirect_to("events path") { admin_events_path }
      should_flash(:notice)
      should "feature the event" do
        assert Event.find(@unfeatured_event.id).is_featured?
        assert !Event.find(@event.id).is_featured?
      end
    end
  end
end