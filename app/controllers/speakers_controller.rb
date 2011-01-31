class SpeakersController < BaseUserController
  include ReCaptcha::ViewHelper
  before_filter :load_event, :only => [:index, :proposals]
  before_filter :prepare_show, :only => [:show]
  before_filter :authenticate_url, :only => [:edit, :update, :destroy]

  def index
    @widget_speakers = @event.speakers.speaker.find(:all, :order => :position, :limit => 16)
    @selected_speaker = @widget_speakers[rand(@widget_speakers.size)]
    
    # past speakers
    @past_speakers = @ignite.speakers.speaker.paginate(:all, :order => :name, :page => params[:page], :per_page => 16)
    
    # set up the left and right columns of speakers
    @left = []
    @right = []
    (0...@past_speakers.size).each do |i|
      (i%2 == 0) ? @left << @past_speakers[i] : @right << @past_speakers[i]
    end
  end
  
  def proposals
    @page_title = "Proposals | #{@event.name}"
    @proposals = @event.speakers.find(:all, :order => :name)
  end

  # GET /speakers/1
  # GET /speakers/1.xml
  def show
    @page_title = "#{@speaker.name} | #{@speaker.title}"
    @comment = Comment.new
    @captcha = get_captcha
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @speaker }
    end
  end

  def post_comment
    @speaker = Speaker.find(params[:id])
    @comment = Comment.new(params[:comment])
    @comment.parent = @speaker
    if validate_captcha(params, @comment) && @comment.save
      ProposalNotifier.deliver_comment_notification(@comment, @speaker) unless @speaker.email.blank?
      ProposalNotifier.deliver_admin_comment_notification(@comment, @speaker) unless @speaker.ignite.emails_as_array.empty?
      flash[:notice] = 'Your comment has been posted.'
      redirect_to speaker_path(@speaker)
    else
      prepare_show
      render :action => "show"
    end
  end
  
  private
    # We're going to want to allow users to follow a link with a special hash to edit their submitted
    # proposals ala Craigslist.  For now just block them out.
    def authenticate_url
      false
    end
    
    def load_event
      @event = params[:event_id] ? @ignite.events.find(params[:event_id]) : @ignite.featured_event
    end
    
    def prepare_show
      @speaker = @ignite.speakers.find(params[:id])
      @event = @speaker.event
      @comments = @speaker.comments
    end
end
