class Admin::IgnitesController < Admin::BaseAdminController
  # GET /ignites
  # GET /ignites.xml
  def index
    @ignites = Ignite.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ignites }
    end
  end

  # GET /ignites/1
  # GET /ignites/1.xml
  def show
    @ignite = Ignite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ignite }
    end
  end

  # GET /ignites/new
  # GET /ignites/new.xml
  def new
    @ignite = Ignite.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ignite }
    end
  end

  # GET /ignites/1/edit
  def edit
    @ignite = Ignite.find(params[:id])
    @organizers = Organizer.all
  end

  # POST /ignites
  # POST /ignites.xml
  def create
    @ignite = Ignite.new(params[:ignite])

    respond_to do |format|
      if @ignite.save
        flash[:notice] = 'Ignite was successfully created.'
        format.html { redirect_to admin_ignite_path(@ignite) }
        format.xml  { render :xml => @ignite, :status => :created, :location => @ignite }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ignite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ignites/1
  # PUT /ignites/1.xml
  def update
    @ignite = Ignite.find(params[:id])

    respond_to do |format|
      if @ignite.update_attributes(params[:ignite])
        flash[:notice] = 'Ignite was successfully updated.'
        format.html { redirect_to admin_ignite_path(@ignite) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ignite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ignites/1
  # DELETE /ignites/1.xml
  def destroy
    @ignite = Ignite.find(params[:id])
    @ignite.destroy

    respond_to do |format|
      format.html { redirect_to(admin_ignites_url) }
      format.xml  { head :ok }
    end
  rescue StandardError => ex
    flash[:error] = ex
    @ignites = Ignite.all
    render :action => 'index'
  end

end
