class Ignite < ActiveRecord::Base
  has_many :events, :dependent => :destroy
  has_many :speakers, :through => :events
  has_many :articles, :dependent => :destroy
  has_many :article_comments, :through => :articles, :source => 'comments'
  has_many :organizers, :dependent => :destroy
  has_many :admins, :dependent => :destroy
  
  file_column :logo_image, :magick => {:versions => {"thumb" => "50x50>"}}
  file_column :banner_background_image, :magick => {:versions => {"thumb" => "50x50>"}}
  file_column :banner_bottom_image, :magick => {:versions => {"thumb" => "50x50>"}}
  
  after_create :create_default_event
  
  validates_presence_of :city, :domain
  validates_uniqueness_of :domain
  validates_size_of :emails, :maximum => 255, :allow_blank => true
  
  def name
    "Ignite #{city}"
  end
  
  def featured_event
    events.find(:first, :order => "is_featured DESC, date DESC")
  end
  
  def next_event_default_name
    "#{name} \##{next_event_position}"
  end
  
  def emails_as_array
    return [] if emails.blank?
    emails.split(",").map(&:strip)
  end
  
  private
    def create_default_event
      Event.create!(:name => next_event_default_name, :date => Date.today, 
                    :ignite => self, :is_featured => true, :accepting_proposals => true)
    end

    def next_event_position
      (self.events.maximum("position") || 0) + 1
    end
  
end
