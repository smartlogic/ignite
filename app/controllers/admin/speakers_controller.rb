class Admin::SpeakersController < Admin::BaseAdminController
  before_filter :load_ignites, :only => [:index, :proposals, :edit, :new, :create, :update]
  def load_ignites
    @ignites = Ignite.all
  end
  
  def csv
    speakers=[]
    if params[:proposal] and !!params[:proposal]
      if params[:ignite_id] and Ignite.exists?(params[:ignite_id])
        speakers = Speaker.proposals.active.find(:all, :conditions => {:ignite_id => params[:ignite_id]}, :order => :name)
      elsif params[:page] and not params[:set]
        speakers = Speaker.paginate(:all, :conditions => "event_id IS NULL", :order => "ignite_id, name", :page => params[:page], :per_page => 16)
      elsif params[:set] and params[:set] == 'active'
        speakers = Speaker.proposals.active
      else
        speakers = Speaker.find(:all, :conditions => "event_id IS NULL", :order => "ignite_id, name")
      end
    else
      if params[:ignite_id] and Ignite.exists?(params[:ignite_id])
        speakers = Speaker.active.find(:all, :conditions => {:ignite_id => params[:ignite_id]}, :order => :name)
      elsif params[:page] and not params[:set]
        speakers = Speaker.paginate(:all, :conditions => "event_id IS NOT NULL", :order => "ignite_id, name", :page => params[:page], :per_page => 16)
      elsif params[:set] and params[:set] == 'active'
        speakers = Speaker.active
      else
        speakers = Speaker.find(:all, :conditions => "event_id IS NOT NULL", :order => "ignite_id, name")
      end
    end
    
    send_data(speakers.to_csv,
              :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=speaker_report_#{Time.now.strftime "%m_%d_%Y"}.csv")
  end
  
  def index
    @speakers = Speaker.paginate(:all, :conditions => "event_id IS NOT NULL", :order => "ignite_id, name", :page => params[:page], :per_page => 16)
    @hide_event = false
    @title = "Listing Speakers"
  end
  
  def proposals
    @speakers = Speaker.paginate(:all, :conditions => "event_id IS NULL", :order => "ignite_id, name", :page => params[:page], :per_page => 16)
    @hide_event = true
    @title = "Listing Proposals"
    render :action => 'index'
  end

  def show
    @speaker = Speaker.find(params[:id])
  end

  def new
    @speaker = Speaker.new
  end

  def edit
    @speaker = Speaker.find(params[:id])
    @events = @speaker.ignite.events
  end

  def update_event_select
    @events = Ignite.find(params[:ignite_id]).events
    render :update do |page|
      page.replace_html 'speaker_event_id', "<option value=\"\">Unassigned Proposal</option>" + options_from_collection_for_select(@events, 'id', 'name')
    end
  end

  def create
    @speaker = Speaker.new(params[:speaker])
    if @speaker.save
      flash[:notice] = 'Speaker was successfully created.'
      redirect_to admin_speaker_path(@speaker)
    else
      render :action => "new"
    end
  end

  def update
    @speaker = Speaker.find(params[:id])
    event_id = params[:speaker].delete("event_id")
    if @speaker.update_attributes(params[:speaker].merge(:event_id => event_id))
      flash[:notice] = 'Speaker was successfully updated.'
      redirect_to admin_speaker_path(@speaker)
    else
      render :action => "edit"
    end
  end

  def destroy
    @speaker = Speaker.find(params[:id])
    @speaker.destroy
    
    redirect_to(admin_speakers_url)
  end
  
  def archive
    @speaker = Speaker.find(params[:id])
    if @speaker.archive!
      flash[:notice] = 'Speaker was successfully archived.'
    else
      flash[:error] = "Speaker could not be archived."
    end
    redirect_to admin_speakers_url
  end
  
end
