class ProposalsController < BaseUserController
  include ReCaptcha::ViewHelper

  def index
    @page_title = "Proposals"
    @proposals = Speaker.find(:all, :conditions => "ignite_id = #{@ignite.id} AND aasm_state = 'active' AND event_id IS NULL", :order => :name)
  end

  # GET /proposals/1
  # GET /proposals/1.xml
  def show
    @proposal = Speaker.active.find(params[:id])
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
    @proposal = Speaker.new(params[:speaker].merge(:ignite => @ignite))

    respond_to do |format|
      if (RAILS_ENV == 'test' || validate_recap(params, @proposal.errors)) && @proposal.save
        flash[:notice] = 'Your Proposal was successfully submitted.'
        format.html { redirect_to article_path(@ignite.articles.find_by_name('Proposal Submitted')) }
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
    if (RAILS_ENV == 'test' || validate_recap(params, @comment.errors)) && @comment.save
      flash[:notice] = 'Your comment has been posted.'
      redirect_to proposal_path(@proposal)
    else
      @comments = @proposal.comments
      @captcha = get_captcha
      render :action => "show"
    end
  end

end
