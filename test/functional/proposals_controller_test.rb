require File.dirname(__FILE__) + '/../test_helper'

class ProposalsControllerTest < ActionController::TestCase
  context "A public visitor to Ignite Baltimore" do
    setup do
      @baltimore = Factory(:ignite, :city => 'Baltimore', :domain => 'ignitebaltimore.localhost')
      set_host(@baltimore)
    end
    
    context "ON GET to index" do
      setup do
        get :index
      end
      should_respond_with :success
      should_render_template 'proposals'
      should "have a page title of Proposals" do
        assert_equal "Proposals", assigns(:page_title)
      end
      should "only show speakers that are actually proposals" do
        assert assigns(:proposals).all?(&:is_proposal?)
      end
      should_render_new_proposal_link
    end

    context "when proposals have been closed" do
      setup do
        @baltimore.update_attributes!(:proposals_closed => true)
      end
      context "ON GET to index" do
        setup do
          get :index
        end
        should_not_render_new_proposal_link
      end
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
      should_redirect_to("proposal page") { proposal_path(@proposal) }
      should_change("number of proposals", :by => 1) { @baltimore.speakers.proposals.count }
      should_flash(:notice)
    end
    
    context "ON POST to create that is unsuccessful" do
      setup do
        post :create, :speaker => Factory.attributes_for(:speaker, :name => nil)
      end
      should_respond_with :success
      should_not_change("number of proposals") { @baltimore.speakers.proposals.count }
      should_render_template 'new'
    end
    
    context "with a proposal" do
      setup do
        @proposal = Factory(:proposal, :ignite => @baltimore, :name => "My Proposal")
      end

      context "ON GET to show" do
        setup do
          get :show, :id => @proposal
        end
        should_respond_with :success
        should_render_template 'show'
        should_assign_to(:proposal) { @proposal }
        should_assign_to(:captcha)
        should_assign_to(:comments)
        should "have a page title of My Proposal | Proposals" do
          assert_equal "My Proposal | Proposals", assigns(:page_title)
        end
        should_render_new_proposal_link
      end
      
      context "when proposal submissions have been closed" do
        setup do
          @baltimore.update_attributes!(:proposals_closed => true)
        end
        context "ON GET to show" do
          setup do
            get :show, :id => @proposal
          end
          should_not_render_new_proposal_link
        end
      end
    
      context "ON POST to post_comment that is successful" do
        setup do
          post :post_comment, {:id => @proposal.id, :comment => Factory.attributes_for(:comment) }
        end
        should_redirect_to("proposal path") { proposal_path(@proposal) }
        should_change("comment count", :by => 1) { @proposal.comments.count }
      end
      
      context "ON POST to post_comment that fails" do
        setup do
          post :post_comment, {:id => @proposal.id, :comment => Factory.attributes_for(:comment, :author => nil)}
        end
        should_respond_with :success
        should_render_template 'show'
        should_not_change("comment count") { @proposal.comments.count }
      end
    end
  end
end
