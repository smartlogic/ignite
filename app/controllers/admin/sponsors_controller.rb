class Admin::SponsorsController < Admin::BaseAdminController

  def index
    @page_title = "Listing Sponsors"
    @sponsors = Sponsor.find(:all)
  end

  def show
    @sponsor = Sponsor.find(params[:id])
  end

  def new
    @sponsor = Sponsor.new
    @events = Event.all
    @selected_events = []
  end

  def edit
    @sponsor = Sponsor.find(params[:id])
    @events = Event.all
    @selected_events = @sponsor.events
  end

  def create
    @sponsor = Sponsor.new(params[:sponsor])
    @sponsor.events = Event.find(params[:event_ids]) if params[:event_ids]
    if @sponsor.save
      flash[:notice] = 'Sponsor was successfully created.'
      redirect_to admin_sponsor_path(@sponsor)
    else
      render :action => "new"
    end
  end

  def update
    @sponsor = Sponsor.find(params[:id])
    @sponsor.events = Event.find(params[:event_ids]) if params[:event_ids]
    if @sponsor.update_attributes(params[:sponsor])
      flash[:notice] = 'Sponsor was successfully updated.'
      redirect_to admin_sponsor_path(@sponsor)
    else
      render :action => "edit"
    end
  end

  def destroy
    @sponsor = Sponsor.find(params[:id])
    @sponsor.destroy

    respond_to do |format|
      format.html { redirect_to(admin_sponsors_url) }
      format.xml  { head :ok }
    end
  end
end
