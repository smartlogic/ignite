class Admin::EventsController < Admin::BaseAdminController
  before_filter :load_ignites, :only => [:edit, :new, :create, :update]
  def load_ignites
    @ignites = Ignite.all
  end
  

  def index
    @events = Event.find(:all, :order => "date DESC")
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
    @organizers = Organizer.all
  end

  def edit
    @event = Event.find(params[:id])
    @organizers = Organizer.all
  end

  def create
    @event = Event.new(params[:event])
    
    respond_to do |format|
      if @event.save
        if @event.is_featured?
          Event.find(:all, :conditions => ["ignite_id = ? AND id != ?", @event.ignite_id, @event.id]).each do |evt|
            evt.update_attribute(:is_featured, false)
          end
        end
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to admin_event_path(@event) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @event = Event.find(params[:id])
    
    respond_to do |format|
      if @event.update_attributes(params[:event])
        @event.update_attribute(:date, @event.date + 18.hours) if @event.date.hour == 0
        if @event.is_featured?
          Event.find(:all, :conditions => "ignite_id = #{@event.ignite.id} AND id != #{@event.id}").each do |evt|
            evt.update_attribute(:is_featured, false)
          end
        end
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to admin_event_path(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(admin_events_url) }
      format.xml  { head :ok }
    end
  rescue StandardError => ex
    flash[:error] = ex
    @events = Event.all
    render :action => 'index'
  end
  
  def set_feature
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attribute(:is_featured, true)
        Event.find(:all, :conditions => "ignite_id = #{@event.ignite.id} AND id != #{@event.id}").each do |evt|
          evt.update_attribute(:is_featured, false)
        end
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to admin_events_url }
        format.xml  { head :ok }
      else
        flash[:error]
        format.html { redirect_to admin_events_url }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end
end
