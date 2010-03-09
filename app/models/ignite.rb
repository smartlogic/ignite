class Ignite < ActiveRecord::Base
  has_many :events, :dependent => :destroy
  has_many :articles, :dependent => :destroy
  has_many :speakers, :dependent => :destroy
  has_many :organizers, :dependent => :destroy
  
  file_column :logo_image, :magick => {:versions => {"thumb" => "50x50>"}}
  file_column :banner_background_image, :magick => {:versions => {"thumb" => "50x50>"}}
  file_column :banner_bottom_image, :magick => {:versions => {"thumb" => "50x50>"}}
  
  after_create :create_default_event
  
  validates_presence_of :city, :domain
  validates_uniqueness_of :domain
  
  def featured_event
    evt = events.find(:first, :conditions => {:is_featured => true})
    evt ? evt : events.find(:first, :order => "date DESC")
  end
  
  private
    def create_default_event
      Event.create!(:name => "Ignite no. 1", :date => Date.today, :ignite => self, 
                    :rsvp_url => "http://ignite-dc.com/", :is_featured => true)
    end
  
end
