require File.dirname(__FILE__) + '/../test_helper'

class SpeakersControllerTest < ActionController::TestCase
  context 'With an ignite site that has a past event with 2 selected speakers and a featured event with 2 selected speakers' do
    setup do
      @ignite = Factory(:ignite, :city => 'Baltimore', :domain => 'ignitebaltimore.localhost')
      @past_event  = @ignite.featured_event
      @current_event = Factory(:featured_event, :ignite => @ignite)
      
      @current_speaker1 = Factory(:speaker, :event => @current_event)
      @current_speaker2 = Factory(:speaker, :event => @current_event)
      @past_speaker1    = Factory(:speaker, :event => @past_event)
      @past_speaker2    = Factory(:speaker, :event => @past_event)
      
      set_host(@ignite)
    end
    
    context 'on GET to index' do
      setup do
        get :index
      end
      should_respond_with :success
      should_render_template 'index'
      should "show the speakers for the current event" do
        assert_equal @current_event, assigns(:event)
        assert [@current_speaker1, @current_speaker2].all? {|sp| assigns(:widget_speakers).include?(sp)}
        assert ![@past_speaker1, @past_speaker2].any?      {|sp| assigns(:widget_speakers).include?(sp)}
      end
    end
    
    context 'with 20 more past speakers (22 total past, 2 total current)' do
      setup do
        20.times { Factory(:speaker, :event => @past_event) }
      end
      context 'on GET to index' do
        setup do
          get :index
        end
        should_respond_with :success
        should "only show 16 past speakers" do
          assert_equal 16, assigns(:past_speakers).size
        end
      end
      context 'on GET to index for page 2' do
        setup do
          get :index, :page => 2
        end
        should_respond_with :success
        should "only show 8 past speakers" do
          assert_equal 8, assigns(:past_speakers).size
        end
      end
    end
    
    context 'on GET to index for a past event' do
      setup do
        get :index, :event_id => @past_event.id
      end
      should_respond_with :success
      should_render_template 'index'
    end
    
    context 'on GET to show' do
      setup do
        get :show, :id => @current_speaker1.id
      end
      should_respond_with :success
      should_render_template 'show'
    end
    
    context 'with 2 comments on a speaker' do
      setup do
        2.times { Factory(:comment, :parent => @current_speaker1) }
      end
      context 'on GET to show' do
        setup do
          get :show, :id => @current_speaker1.id
        end
        should_respond_with :success
        should_render_template 'show'
        should 'show 2 comments' do
          assert_equal 2, assigns(:comments).size
        end
      end
    end
    
    context 'on POST to post_comment that is successful' do
      setup do
        post :post_comment, :id => @current_speaker1.id, :comment => Factory.attributes_for(:comment)
      end
      should_redirect_to('speaker') { speaker_path(@current_speaker1) }
      should_flash(:notice)
      should_change('number of comments', :by => 1) { @current_speaker1.comments.count }
    end
    
    context 'on POST to post_comment that fails' do
      setup do
        post :post_comment, :id => @current_speaker1.id, :comment => Factory.attributes_for(:comment, :author => nil)
      end
      should_respond_with :success
      should_render_template 'show'
    end
  end
  
  context 'With an event that has two proposals' do
    setup do
      @ignite = Factory(:ignite, :city => 'Baltimore', :domain => 'ignitebaltimore.localhost')
      @event  = @ignite.featured_event
      set_host(@ignite)
      
      @proposal1 = Factory(:proposal, :event => @event)
      @proposal2 = Factory(:proposal, :event => @event)
    end

    context 'on GET to proposals' do
      setup do
        get :proposals
      end
      should_respond_with :success
      should_render_template 'proposals'
      should "have a page title" do
        assert_equal "Proposals | #{@event.name}", assigns(:page_title)
      end
      should "only show speakers that are actually proposals" do
        assert assigns(:proposals).all?(&:proposal?)
      end
      should_render_new_proposal_link
    end
    
    context "when proposals have been closed" do
      setup do
        @event.update_attributes!(:accepting_proposals => false)
      end
      context "ON GET to proposals" do
        setup do
          get :proposals
        end
        should_not_render_new_proposal_link
      end
    end
  end
end
