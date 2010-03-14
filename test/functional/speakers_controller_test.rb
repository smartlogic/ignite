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
  end
  
  # 
  # test "should post comment to speaker" do
  #   exp_comments_cnt = brian.comments.size + 1
  #   assert_difference 'Comment.count' do
  #     post :post_comment, {:id => brian.id, :comment => {:author => "me", :email => "none", :url => "none", :content => "asdfasdfasdf"} }
  #   end
  #   assert_equal brian.comments(true).size, exp_comments_cnt
  #   assert_redirected_to speaker_url(brian)
  # end
  # 
  # test "should fail to post comment because of no name" do
  #   exp_comments_cnt = brian.comments.size
  #   assert_no_difference 'Comment.count' do
  #     post :post_comment, {:id => brian.id, :comment => {} }
  #   end
  #   assert_equal brian.comments(true).size, exp_comments_cnt
  #   assert_template 'show'
  # end

end
