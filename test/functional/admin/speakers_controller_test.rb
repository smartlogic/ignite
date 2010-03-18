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
          assert_equal 2, assigns(:speakers).size
          assert [@proposal1, @proposal2].all? {|prop| assigns(:speakers).include?(prop)}
        end
      end
      
      context 'on GET to index with :state => "archived"' do
        setup do
          get :index, :state => 'archived'
        end
        should "show the one archived proposal" do
          assert_equal 1, assigns(:speakers).size
          assert assigns(:speakers).include?(@archived)
        end
      end
      
      context 'on GET to index with :state => "speaker"' do
        setup do
          get :index, :state => 'speaker'
        end
        should "show the one speaker" do
          assert_equal 1, assigns(:speakers).size
          assert assigns(:speakers).include?(@speaker)
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
      
      context 'on DELETE to destroy' do
        setup do
          delete :destroy, :id => @proposal1.id, :state => 'archived', :event => @event.id
        end
        should_redirect_to("index with filters") { admin_speakers_path(:state => 'archived', :event => @event.id) }
        should_flash(:notice)
        should_change("number of speakers", :by => -1) { @event.speakers.count }
      end
      
      context 'on PUT to archive' do
        setup do
          put :archive, :id => @proposal1.id, :state => 'proposal', :event => @event.id
          @proposal1.reload
        end
        should_redirect_to("index with filters") { admin_speakers_path(:state => 'proposal', :event => @event.id) }
        should_flash(:notice)
        should_change("number of active proposals", :by => -1) { @event.speakers.proposal.count }
        should_change("number of archived proposals", :by => 1) { @event.speakers.archived.count }
        should_change("state of proposal", :from => 'proposal', :to => 'archived') { @proposal1.aasm_state }
      end
      
      context 'on PUT to unarchive' do
        setup do
          put :unarchive, :id => @archived.id, :state => 'archived', :event => @event.id
          @archived.reload
        end
        should_redirect_to("index with filters") { admin_speakers_path(:state => 'archived', :event => @event.id) }
        should_flash(:notice)
        should_change("number of archived proposals", :by => -1) { @event.speakers.archived.count }
        should_change("number of active proposals", :by => 1) { @event.speakers.proposal.count }
        should_change("state of proposal", :from => 'archived', :to => 'proposal') { @archived.aasm_state }
      end
      
      context 'on PUT to reconsider' do
        setup do
          put :reconsider, :id => @speaker.id, :state => 'speaker', :event => @event.id
          @speaker.reload
        end
        should_redirect_to("index with filters") { admin_speakers_path(:state => 'speaker', :event => @event.id) }
        should_flash(:notice)
        should_change("number of speakers", :by => -1) { @event.speakers.speaker.count }
        should_change("number of proposals", :by => 1) { @event.speakers.proposal.count }
        should_change("state of speaker", :from => 'speaker', :to => 'proposal') { @speaker.aasm_state }
      end
      
      context 'on PUT to choose' do
        setup do
          put :choose, :id => @proposal1.id, :state => 'proposal', :event => @event.id
          @proposal1.reload
        end
        should_redirect_to("index with filters") { admin_speakers_path(:state => 'proposal', :event => @event.id) }
        should_flash(:notice)
        should_change("number of speakers", :by => 1) { @event.speakers.speaker.count }
        should_change("number of proposals", :by => -1) { @event.speakers.proposal.count }
        should_change("state of proposal", :from => 'proposal', :to => 'speaker') { @proposal1.aasm_state }
      end
    end
  end
end
