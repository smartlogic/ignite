class Admin::IgnitesController < Admin::BaseAdminController
  before_filter :local_load_ignite, :only => [:show, :edit, :update]
  before_filter :require_superadmin, :only => [:index, :new, :create]
  load_and_authorize_resource :only => [:show, :edit, :update]
  
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

  # GET /ignites/1/edit
  def edit
    @organizers = Organizer.all
  end

  # PUT /ignites/1
  # PUT /ignites/1.xml
  def update
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
  
  private
    def local_load_ignite
      @ignite = Ignite.find(params[:id])
    end
    
    def require_superadmin
      unauthorized! if !current_admin.superadmin?
    end

end
