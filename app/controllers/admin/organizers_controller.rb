class Admin::OrganizersController < Admin::BaseAdminController
  before_filter :load_ignites, :only => [:edit, :new, :create, :update]
  def load_ignites
    @ignites = Ignite.all
  end
  

  def index
    @page_title = "Listing Organizers"
    @organizers = Organizer.find(:all, :order => "ignite_id, name")
  end


  def show
    @organizer = Organizer.find(params[:id])
  end

  def new
    @roles = OrganizerRole.all
    @organizer = Organizer.new
  end

  def edit
    @roles = OrganizerRole.all
    @organizer = Organizer.find(params[:id])
  end

  def create
    @organizer = Organizer.new(params[:organizer])

    respond_to do |format|
      if @organizer.save
        flash[:notice] = 'Organizer was successfully created.'
        format.html { redirect_to admin_organizer_path(@organizer) }
        format.xml  { render :xml => @organizer, :status => :created, :location => @organizer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organizer.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @organizer = Organizer.find(params[:id])

    respond_to do |format|
      if @organizer.update_attributes(params[:organizer])
        flash[:notice] = 'Organizer was successfully updated.'
        format.html { redirect_to admin_organizer_path(@organizer) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organizer.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @organizer = Organizer.find(params[:id])
    @organizer.destroy

    respond_to do |format|
      format.html { redirect_to(admin_organizers_url) }
      format.xml  { head :ok }
    end
  end
end
