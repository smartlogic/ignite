class SpeakersController < BaseUserController
  include ReCaptcha::ViewHelper
  before_filter :load_event, :only => [:index]
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
    @proposals = Speaker.find(:all, :conditions => "aasm_state = 'active' AND event_id IS NULL", :order => :name)
  end

  # GET /speakers/1
  # GET /speakers/1.xml
  def show
    @speaker = @ignite.speakers.find(params[:id])
    @event = @speaker.event
    @comments = @speaker.comments
    @comment = Comment.new
    @captcha = get_captcha
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @speaker }
    end
  end

  # GET /speakers/1/edit
  def edit
    @speaker = Speaker.find(params[:id])
  end

  # PUT /speakers/1
  # PUT /speakers/1.xml
  def update
    @speaker = Speaker.find(params[:id])

    respond_to do |format|
      if @speaker.update_attributes(params[:speaker])
        flash[:notice] = 'Speaker was successfully updated.'
        format.html { redirect_to(@speaker) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @speaker.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /speakers/1
  # DELETE /speakers/1.xml
  def destroy
    @speaker = Speaker.find(params[:id])
    @speaker.destroy

    respond_to do |format|
      format.html { redirect_to(speakers_url) }
      format.xml  { head :ok }
    end
  end
  
  def post_comment
    @speaker = Speaker.find(params[:id])
    @comment = Comment.new(params[:comment])
    @comment.parent = @speaker
    if validate_captcha(params, @comment) && @comment.save
      flash[:notice] = 'Your comment has been posted.'
      redirect_to speaker_path(@speaker)
    else
      @event = @speaker.event.nil? ? Event.first : @speaker.event
      @comments = @speaker.comments
      @social_links = @speaker.social_links
      @captcha = get_captcha
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
end
