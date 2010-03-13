class Event < ActiveRecord::Base
  has_many :speakers, :order => :position, :dependent => :destroy
  has_many :comments, :as => :parent, :dependent => :destroy
  belongs_to :organizer
  belongs_to :ignite
  has_and_belongs_to_many :sponsors
  has_and_belongs_to_many :organizers

  acts_as_list :scope => :ignite
  file_column :summary_image

  validates_presence_of :ignite_id

  before_save :ensure_only_one_event_featured
  before_destroy :disallow_only_event_to_be_destroyed
  after_create :assign_all_organizers

  named_scope :by_date_desc, :order => "date DESC"
  named_scope :past, lambda {
    { :conditions => ["is_complete = 1 OR date < ?", Date.today], :order => "date DESC" }
  }
  
  def name
    "Ignite #{ignite.city} \##{self.position}"
  end
  
  def past?
    self.is_complete? || self.date < Date.today
  end
  
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
    def disallow_only_event_to_be_destroyed
      evt = self.ignite.events.find(:first, :conditions => "id != #{self.id}", :order => "date DESC")
      if evt.nil?
        raise(StandardError, "You cannot delete the only candidate for #{ignite.city}'s featured event!")
      else
        evt.update_attribute(:is_featured, true)
      end
    end

    def ensure_only_one_event_featured
      if self.is_featured?
        self.ignite.events.update_all("is_featured = 0")
      elsif !self.is_featured? && self.is_featured_changed?
        errors.add_to_base("at least one event must be featured")
        false
      end
    end
    
    def assign_all_organizers
      self.organizers.replace(self.ignite.organizers(true))
    end
end
