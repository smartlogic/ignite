class ProposalsController < BaseUserController
  include ReCaptcha::ViewHelper
  
  before_filter :load_event

  def new
    unless @ignite.proposals_closed
      @page_title = "Submit a Proposal"
      @proposal = Speaker.new
      @captcha = get_captcha
    else
      flash[:error] = "Proposals are not currently being accepted.  Stay tuned for the next round!"
      redirect_to proposals_path
    end
  end

  def create
    @proposal = Speaker.new(params[:speaker].merge(:event => @event, :aasm_state => 'proposal'))

    respond_to do |format|
      if validate_captcha(params, @proposal) && @proposal.save
        flash[:notice] = 'Your Proposal was successfully submitted.'
        format.html { redirect_to speaker_path(@proposal) }
        format.xml  { render :xml => @proposal, :status => :created, :location => @proposal }
      else
        @captcha = get_captcha
        format.html { render :action => "new" }
        format.xml  { render :xml => @proposal.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
    def load_event
      @event = @ignite.featured_event
    end

end
