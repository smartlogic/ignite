require 'ostruct'
require 'fastercsv'
class Admin::SpeakersController < Admin::BaseAdminController
  before_filter :load_speaker, :only => [:show, :edit, :update, :destroy, :archive, :unarchive, :reconsider, :choose]
  before_filter :load_url_params, :only => [:index, :csv, :archive, :destroy, :archive, :unarchive, :reconsider, :choose]
  before_filter :load_events, :only => [:index]
  before_filter :load_states, :only => [:index]
  before_filter :load_speakers, :only => [:index, :csv]
  
  helper_method :url_params
  
  def index
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
    flash[:notice] = "Proposal #{@speaker.title} has been selected for #{@event.name}."
    redirect_to admin_speakers_path(url_params)
  end

  def csv
    name = "#{@ignite.city}-#{@state.name}-report-#{Time.now.strftime '%m_%d_%Y'}"
    send_data(csv_for(@speakers),
      :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=#{name}.csv")
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
    
    def load_speakers
      @speakers = @event.speakers.send(@state.name).find(:all, :order => "name")
    end

    def url_params
      {:state => @state.name, :event => @event.id}
    end
    
    def csv_for(speakers)
      FasterCSV.generate do |csv|
        csv << %w(name email title state event admin_url public_url description bio)
        speakers.each do |speaker|
          csv << [speaker.name, speaker.email, speaker.title, speaker.aasm_state, speaker.event.name, admin_speaker_path(speaker),
            speaker_path(speaker), speaker.description, speaker.bio]
        end
      end
    end
end
