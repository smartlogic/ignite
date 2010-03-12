class Admin::AdminsController < Admin::BaseAdminController
  before_filter :find_all_admins, :only => [:index]
  before_filter :find_admin, :only => [:show, :edit, :update, :destroy]
  
  # GET /admins
  # GET /admins.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admins }
    end
  end

  # GET /admins/1
  # GET /admins/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @admin }
    end
  end

  # GET /admins/new
  # GET /admins/new.xml
  def new
    @admin = Admin.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @admin }
    end
  end

  # POST /admins
  # POST /admins.xml
  def create
    @admin = Admin.new(params[:admin])

    respond_to do |format|
      if @admin.save
        flash[:notice] = 'Admin was successfully created.'
        format.html { redirect_to admin_admin_path(@admin) }
        format.xml  { render :xml => @admin, :status => :created, :location => @admin }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /admins/1/edit
  def edit

  end

  # PUT /admins/1
  # PUT /admins/1.xml
  def update
    respond_to do |format|
      if @admin.update_attributes(params[:admin])
        flash[:notice] = 'Admin was successfully updated.'
        format.html { redirect_to admin_admin_path(@admin) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1
  # DELETE /admins/1.xml
  def destroy
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to(admin_admins_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
    def find_all_admins
      @admins = Admin.find(:all, :conditions => ["ignite_id = ? OR ignite_id IS NULL", @ignite.id])
    end
    
    def find_admin
      @admin = if current_admin.superadmin?
        Admin.find_by_id(params[:id])
      else
        @ignite.admins.find(params[:id])
      end
      if @admin.nil? || (@admin.superuser? && !current_admin.superadmin?)
        flash[:error] = "Access Denied"
        redirect_to admin_admins_path
      end
    end
end
