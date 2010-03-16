class Admin::EventsController < Admin::BaseAdminController
  before_filter :load_event, :only => [:show, :edit, :update, :destroy, :set_feature]
  before_filter :load_organizers, :only => [:new, :edit]
  
  def index
    @events = @ignite.events.by_date_desc
  end

  def show

  end

  def new
    @event = Event.new(:name => @ignite.next_event_default_name)
  end

  def create
    @event = Event.new(params[:event].merge(:ignite => @ignite))
    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to admin_event_path(@event) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { 
          load_organizers
          render :action => "new" 
        }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    
  end

  def update
    respond_to do |format|
      if @event.update_attributes(params[:event].merge(:ignite => @ignite))
        @event.update_attribute(:date, @event.date + 18.hours) if @event.date.hour == 0
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to admin_event_path(@event) }
        format.xml  { head :ok }
      else
        format.html { 
          load_organizers
          render :action => "edit" 
        }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.destroy

    respond_to do |format|
      format.html {
        flash[:notice] = "Event destroyed"
        redirect_to(admin_events_path)
      }
      format.xml  { head :ok }
    end
  rescue StandardError => ex
    flash[:error] = ex.message
    redirect_to admin_events_path
  end
  
  def set_feature
    respond_to do |format|
      if @event.update_attributes(:is_featured => true)
        format.html { 
          flash[:notice] = 'Event is now featured.'
          redirect_to admin_events_url 
        }
        format.xml  { head :ok }
      else
        format.html { 
          flash[:error] = "Unable to feature event."
          redirect_to admin_events_url
        }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
    def load_event
      @event = @ignite.events.find(params[:id])
    end
    
    def load_organizers
      @organizers = @ignite.organizers
    end
end
