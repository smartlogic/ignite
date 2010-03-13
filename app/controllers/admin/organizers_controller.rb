class Admin::OrganizersController < Admin::BaseAdminController
  before_filter :load_organizer, :only => [:show, :edit, :update, :destroy]
  before_filter :load_events, :only => [:new, :edit]
  
  def index
    @page_title = "Listing Organizers"
    @organizers = @ignite.organizers.find(:all, :order => "ignite_id, name")
  end

  def show
    
  end

  def new
    @organizer = Organizer.new
  end

  def create
    @organizer = Organizer.new(params[:organizer])
    @organizer.ignite = @ignite

    respond_to do |format|
      if @organizer.save
        flash[:notice] = 'Organizer was successfully created.'
        format.html { redirect_to admin_organizer_path(@organizer) }
        format.xml  { render :xml => @organizer, :status => :created, :location => @organizer }
      else
        format.html { 
          load_events
          render :action => "new" 
        }
        format.xml  { render :xml => @organizer.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    
  end

  def update
    respond_to do |format|
      params[:organizer][:event_ids] ||= []
      if @organizer.update_attributes(params[:organizer])
        flash[:notice] = 'Organizer was successfully updated.'
        format.html { redirect_to admin_organizer_path(@organizer) }
        format.xml  { head :ok }
      else
        format.html { 
          load_events
          render :action => "edit" 
        }
        format.xml  { render :xml => @organizer.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @organizer.destroy

    respond_to do |format|
      format.html { 
        flash[:notice] = "#{@organizer.name} was removed"
        redirect_to(admin_organizers_url) 
      }
      format.xml  { head :ok }
    end
  end
  
  protected
    def load_organizer
      @organizer = Organizer.find(params[:id])
    end
    
    def load_events
      @events = @ignite.events
    end
end
