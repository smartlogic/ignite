require File.dirname(__FILE__) + '/../test_helper'

class ProposalsControllerTest < ActionController::TestCase
  context "A public visitor to Ignite Baltimore" do
    setup do
      @baltimore = Factory(:ignite, :city => 'Baltimore', :domain => 'ignitebaltimore.localhost')
      @event = @baltimore.featured_event
      set_host(@baltimore)
    end
    
    context "ON GET to new" do
      setup do
        get :new
      end
      should_respond_with :success
      should_render_template 'new'
      should "have a page title of Submit a Proposal" do
        assert_equal "Submit a Proposal", assigns(:page_title)
      end
    end
    
    context "ON POST to create that is successful" do
      setup do
        post :create, :speaker => Factory.attributes_for(:speaker, :event_id => nil)
        @proposal = Speaker.last
      end
      should_redirect_to("proposal page") { speaker_path(@proposal) }
      should_change("number of proposals", :by => 1) { @event.speakers.proposal.count }
      should_flash(:notice)
    end
    
    context "ON POST to create that is unsuccessful" do
      setup do
        post :create, :speaker => Factory.attributes_for(:speaker, :name => nil)
      end
      should_respond_with :success
      should_not_change("number of proposals") { @event.speakers.proposal.count }
      should_render_template 'new'
    end
  end
end
