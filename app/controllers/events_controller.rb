class EventsController < BaseUserController
  include Recaptcha::Verify
  include Recaptcha::ClientHelper

  def index
    @events = @ignite.events.by_date_desc
    eid = @ignite.articles.find_by_name('EventsIndexDescription')
    @events_index_description = eid ? eid.html_text : "<h3>Create an article named \"EventsIndexDescription\" to replace this text.</h3>"
    @page_title = "Events"
  end

  def show
    @event = @ignite.events.find(params[:id])
    @page_title = "#{@event.name} | Events"
    @comment = Comment.new
    prepare_show
  end

  def past
    @events = @ignite.events.past.by_date_desc
    @page_title = "Past Events"
    ped = @ignite.articles.find_by_name('PastEventsDescription')
    @past_events_description = ped ? ped.html_text : "<h3>Create an article named \"PastEventsDescription\" to replace this text.</h3>"
  end
  
  def post_comment
    @event = @ignite.events.find(params[:id])
    @comment = Comment.new(params[:comment])
    @comment.parent = @event
    if validate_captcha(params, @comment) && @comment.save
      flash[:notice] = 'Your comment has been posted.'
      redirect_to event_path(@event)
    else
      prepare_show
      render :action => "show"
    end
  end
  
  private
    def prepare_show
      @comments = @event.comments
      @speakers = @event.speakers
      @captcha = recaptcha_tags
      gii = @ignite.articles.find_by_name('GetInvolvedInfo')
      @get_involved_info = gii ? gii.html_text : "<h3>Create an article named \"GetInvolvedInfo\" to replace this text.</h3>"
    end

end
