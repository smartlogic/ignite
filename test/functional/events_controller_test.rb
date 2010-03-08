require File.dirname(__FILE__) + '/../test_helper'

class EventsControllerTest < ActionController::TestCase
  context "A public visitor to Ignite Baltimore" do
    setup do
      @baltimore = Factory(:ignite, :city => 'Baltimore', :domain => 'ignitebaltimore.localhost')
      @current_event = @baltimore.featured_event
      set_host(@baltimore)
    end

    context "on GET to index" do
      setup do
        get :index
      end
      should_respond_with :success
      should_render_template 'index'
      should "set page title to Events" do
        assert_equal "Events", assigns(:page_title)
      end
    end
    
    context "with 2 past events and one current one" do
      setup do
        @past_event     = Factory(:past_event, :ignite => @baltimore, :date => Date.today - 30)
        @past_event2    = Factory(:past_event, :ignite => @baltimore, :date => Date.today - 60)
        
        [@current_event, @past_event, @past_event2].each do |evt|
          2.times { Factory(:speaker, :event => evt, :ignite => @baltimore) }
        end
      end
      
      context "on GET to past" do
        setup do
          get :past
        end
        should_respond_with :success
        should_render_template 'past'
        should "only show the past events" do
          assert_equal 2, assigns(:events).size
          assert assigns(:events).all? {|event| event.past?}
        end
        should "sort events in descending order" do
          assert_equal [@past_event, @past_event2], assigns(:events)
        end
      end
      
      context "on GET to show for current event" do
        setup do
          get :show, :id => @current_event.id
        end
        should_respond_with :success
        should_render_template 'show'
        should "only show current event's speakers" do
          assert assigns(:speakers).all? {|evt| evt.event == @current_event}
        end
        should "set the title" do
          assert_equal "#{@current_event.name} | Events", assigns(:page_title)
        end
      end
    end
    
    context "on POST to post_comment that is successful" do
      setup do
        post :post_comment, {:id => @current_event.id, :comment => Factory.attributes_for(:comment) }
      end
      should_redirect_to("event page") { event_path(@current_event) }
      should_flash(:notice)
      should_change("number of comments", :by => 1) { @current_event.comments.count }
    end
    
    context "on POST to post_comment that fails" do
      setup do
        post :post_comment, {:id => @current_event.id, :comment => Factory.attributes_for(:comment, :author => nil)}
      end
      should_respond_with :success
      should_render_template 'show'
      should_not_change("number of comments") { @current_event.comments.count }
    end
  end

end