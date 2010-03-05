class Event < ActiveRecord::Base
  acts_as_list :scope => :ignite
  
  has_many :speakers, :order => :position
  has_many :comments, :as => :parent, :dependent => :destroy
  belongs_to :organizer
  belongs_to :ignite
  has_and_belongs_to_many :sponsors

  file_column :summary_image

  validates_presence_of :ignite_id
  before_destroy :clear_event_key

  named_scope :past, :conditions => "is_complete = true OR date < '#{Date.today}'", :order => "date DESC"
  
  def content_links
    links = {}
    ['images_url', 'videos_url', 'sponsors_url'].each do |link|
      unless self.send(link).blank?
        links[link.match(/^(\w+)_url/)[1].capitalize] = self.send(link)
      end
    end
    links
  end

  private
    def clear_event_key
      evt = Event.find(:first, :conditions => "ignite_id = #{ignite.id} AND id != #{self.id}", :order => "date DESC")
      if evt.nil?
        raise(StandardError, "You cannot delete the only candidate for #{ignite.city}'s featured event!")
        return false
      else
        evt.update_attribute(:is_featured, true)
        speakers.each {|speaker| speaker.update_attribute(:event_id, nil)}
      end
    end

end
