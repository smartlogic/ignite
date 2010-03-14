require File.dirname(__FILE__) + '/../../test_helper'

class Admin::SpeakersControllerTest < ActionController::TestCase
  context 'With an admin logged in' do
    setup do
      @admin = Factory(:admin)
      @ignite = Factory(:ignite, :city => 'Baltimore', :domain => 'ignitebaltimore.localhost')
      set_host(@ignite)
      log_in @admin
    end
    
    context 'with two events' do
      setup do
        @featured_event = @ignite.featured_event
        @other_event    = Factory(:event, :ignite => @ignite)
      end
      context "on GET to index without any parameters" do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template 'index'
        should "default to featured event" do
          assert_equal @featured_event, assigns(:event)
        end
        should "default to proposal state" do
          assert_equal :proposal, assigns(:state).name
        end
      end
    end
    
    context 'with an event with 2 proposals, 1 archived and 1 speaker' do
      setup do
        @event = @ignite.featured_event
        @proposal1 = Factory(:speaker, :event => @event, :aasm_state => 'proposal')
        @proposal2 = Factory(:speaker, :event => @event, :aasm_state => 'proposal')
        @archived  = Factory(:speaker, :event => @event, :aasm_state => 'archived')
        @speaker   = Factory(:speaker, :event => @event, :aasm_state => 'speaker')
      end
      
      context 'on GET to index with :state => "proposal"' do
        setup do
          get :index, :state => 'proposal'
        end
        should "show the two proposals" do
          assert_equal 2, assigns(:proposals).size
          assert [@proposal1, @proposal2].all? {|prop| assigns(:proposals).include?(prop)}
        end
      end
      
      context 'on GET to index with :state => "archived"' do
        setup do
          get :index, :state => 'archived'
        end
        should "show the one archived proposal" do
          assert_equal 1, assigns(:proposals).size
          assert assigns(:proposals).include?(@archived)
        end
      end
      
      context 'on GET to index with :state => "speaker"' do
        setup do
          get :index, :state => 'speaker'
        end
        should "show the one speaker" do
          assert_equal 1, assigns(:proposals).size
          assert assigns(:proposals).include?(@speaker)
        end
      end
      
      context 'on GET to show' do
        setup do
          get :show, :id => @proposal1.id
        end
        should_respond_with :success
        should_render_template 'show'
      end
      
      context 'on GET to edit' do
        setup do
          get :edit, :id => @proposal1.id
        end
        should_respond_with :success
        should_render_template 'edit'
      end
      
      context 'on PUT to update that is successful' do
        setup do
          put :update, :id => @proposal1.id, :speaker => Factory.attributes_for(:speaker)
        end
        should_redirect_to("show") { admin_speaker_path(@proposal1) }
        should_flash(:notice)
      end
      
      context 'on PUT to update that fails' do
        setup do
          put :update, :id => @proposal1.id, :speaker => Factory.attributes_for(:speaker, :name => nil)
        end
        should_respond_with :success
        should_render_template 'edit'
      end
      
      should "destroy a speaker"
      should "archive a proposal"
      should "mark a proposal as a speaker"
    end
  end
  
  # test "should destroy speaker with dependent comments" do
  #   assert chris.comments.size > 0
  #   exp_comment_cnt = Comment.count - chris.comments.size
  #   assert_difference('Speaker.count', -1) do
  #     log_in(ggentzke) do
  #       delete :destroy, :id => chris.id
  #     end
  #   end
  #   assert_equal exp_comment_cnt, Comment.count
  #   assert_redirected_to admin_speakers_path
  # end
end
