require 'ostruct'
class Admin::SpeakersController < Admin::BaseAdminController
  before_filter :load_speaker, :only => [:show, :edit, :update, :destroy, :archive, :unarchive, :reconsider, :choose]
  before_filter :load_url_params, :only => [:index, :archive, :destroy, :archive, :unarchive, :reconsider, :choose]
  before_filter :load_events, :only => [:index]
  before_filter :load_states, :only => [:index]
  
  helper_method :url_params
  
  def index
    @proposals = @event.speakers.send(@state.name).find(:all, :order => "name")
    @title = "Proposals | #{@ignite.city}"
  end
  
  def show
    
  end

  def edit

  end

  def update
    if @speaker.update_attributes(params[:speaker])
      flash[:notice] = 'Speaker was successfully updated.'
      redirect_to admin_speaker_path(@speaker)
    else
      render :action => "edit"
    end
  end

  def destroy
    @speaker.destroy
    flash[:notice] = "#{@speaker.title} has been removed."
    redirect_to admin_speakers_path(url_params)
  end
  
  def archive
    @speaker.archive!
    flash[:notice] = "Proposal #{@speaker.title} has been archived."
    redirect_to admin_speakers_path(url_params)
  end
  
  def unarchive
    @speaker.unarchive!
    flash[:notice] = "Proposal #{@speaker.title} has been unarchived."
    redirect_to admin_speakers_path(url_params)
  end
  
  def reconsider
    @speaker.reconsider!
    flash[:notice] = "Speaker #{@speaker.title} is now being reconsidered as a proposal."
    redirect_to admin_speakers_path(url_params)
  end
  
  def choose
    @speaker.choose!
    flash[:notice] = "Proposal #{@speaker.title} has been seleted for #{@event.name}."
    redirect_to admin_speakers_path(url_params)
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
  
  protected
    def load_speaker
      @speaker = @ignite.speakers.find(params[:id])
    end
    
    def load_events
      @events = @ignite.events
    end
    
    def load_states
      @states = Speaker.aasm_states
    end
    
    def load_url_params
      @event = Event.find_by_id(params[:event]) || @ignite.featured_event
      state_name = params.fetch(:state) { 'proposal' }
      @state = Speaker.aasm_states.detect {|aasm_state| aasm_state.name.to_s == state_name}
    end
    
    def url_params
      {:state => @state.name, :event => @event.id}
    end
end
