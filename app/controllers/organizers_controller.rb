class OrganizersController < BaseUserController
  before_filter :load_event
  
  def index
    @page_title = "Organizers | #{@event.name}"
    @organizers = @event.organizers
  end

  def show
    @organizer = @event.organizers.find(params[:id])
    @page_title = "#{@organizer.name} | #{@event.name}"
  end

  protected
    def load_event
      @event = @ignite.featured_event
    end
end
