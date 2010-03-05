class Admin::OrganizerRolesController < Admin::BaseAdminController
  # GET /organizer_roles
  # GET /organizer_roles.xml
  def index
    @organizer_roles = OrganizerRole.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @organizer_roles }
    end
  end

  # GET /organizer_roles/1
  # GET /organizer_roles/1.xml
  def show
    @organizer_role = OrganizerRole.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @organizer_role }
    end
  end

  # GET /organizer_roles/new
  # GET /organizer_roles/new.xml
  def new
    @organizer_role = OrganizerRole.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @organizer_role }
    end
  end

  # GET /organizer_roles/1/edit
  def edit
    @organizer_role = OrganizerRole.find(params[:id])
  end

  # POST /organizer_roles
  # POST /organizer_roles.xml
  def create
    @organizer_role = OrganizerRole.new(params[:organizer_role])

    respond_to do |format|
      if @organizer_role.save
        flash[:notice] = 'OrganizerRole was successfully created.'
        format.html { redirect_to admin_organizer_role_path(@organizer_role) }
        format.xml  { render :xml => @organizer_role, :status => :created, :location => @organizer_role }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organizer_role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /organizer_roles/1
  # PUT /organizer_roles/1.xml
  def update
    @organizer_role = OrganizerRole.find(params[:id])

    respond_to do |format|
      if @organizer_role.update_attributes(params[:organizer_role])
        flash[:notice] = 'OrganizerRole was successfully updated.'
        format.html { redirect_to admin_organizer_role_path(@organizer_role) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organizer_role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /organizer_roles/1
  # DELETE /organizer_roles/1.xml
  def destroy
    @organizer_role = OrganizerRole.find(params[:id])
    @organizer_role.destroy

    respond_to do |format|
      format.html { redirect_to(admin_organizer_roles_url) }
      format.xml  { head :ok }
    end
  end
end
