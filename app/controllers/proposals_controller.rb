class ProposalsController < BaseUserController
  include ReCaptcha::ViewHelper
  
  before_filter :load_event, :except => [:edit]
  before_filter :load_proposal, :only => [:edit, :update]
  
  def index
    redirect_to proposals_speakers_path
  end

  def new
    if @event.accepting_proposals?
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
        ProposalNotifier.deliver_admin_notification(@proposal) unless @proposal.ignite.emails_as_array.empty?
        ProposalNotifier.deliver_thank_you(@proposal)          unless @proposal.email.blank?
        flash[:notice] = 'Thank you for your proposal!  You will be contacted by email when your submission has been reviewed.'
        format.html { redirect_to speaker_path(@proposal) }
        format.xml  { render :xml => @proposal, :status => :created, :location => @proposal }
      else
        @captcha = get_captcha
        format.html { render :action => "new" }
        format.xml  { render :xml => @proposal.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    
  end
  
  def update
    if validate_captcha(params, @proposal) && @proposal.update_attributes(params[:speaker])
      flash[:notice] = 'Your proposal has been updated'
      redirect_to speaker_path(@proposal)
    else
      @captcha = get_captcha
      render :action => 'edit'
    end
  end
  
  private
    def load_event
      @event = @ignite.featured_event
    end
    
    def load_proposal
      @proposal = Speaker.proposal.find_by_key(params[:key])

      if !@proposal || @proposal.id != params[:id].to_i
        flash[:error] = "Invalid key"
        redirect_to proposals_speakers_path
      elsif !@proposal.event.accepting_proposals?
        flash[:error] = "Proposal submission is no longer open, you can no longer edit this proposal."
        redirect_to proposals_speakers_path
      end
    end

end
