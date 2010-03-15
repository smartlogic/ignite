class ProposalsController < BaseUserController
  include ReCaptcha::ViewHelper
  
  before_filter :load_event

  def index
    @page_title = "Proposals"
    @proposals = @event.speakers.proposal.find(:all, :order => :name)
  end

  # GET /proposals/1
  # GET /proposals/1.xml
  def show
    @proposal = @event.speakers.proposal.find(params[:id])
    @page_title = "#{@proposal.name} | Proposals"
    @comments = @proposal.comments
    @comment = Comment.new
    @captcha = get_captcha

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @proposal }
    end
  end

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
        format.html { redirect_to proposal_path(@proposal) }
        format.xml  { render :xml => @proposal, :status => :created, :location => @proposal }
      else
        @captcha = get_captcha
        format.html { render :action => "new" }
        format.xml  { render :xml => @proposal.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def post_comment
    @proposal = Speaker.find(params[:id])
    @comment = Comment.new(params[:comment])
    @comment.parent = @proposal
    if validate_captcha(params, @comment) && @comment.save
      flash[:notice] = 'Your comment has been posted.'
      redirect_to proposal_path(@proposal)
    else
      @comments = @proposal.comments
      @captcha = get_captcha
      render :action => "show"
    end
  end
  
  private
    def load_event
      @event = @ignite.featured_event
    end

end
