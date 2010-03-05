class Organizer < ActiveRecord::Base
  belongs_to :ignite
  belongs_to :organizer_role
  has_one :event
  
  before_destroy :clear_event_key
  before_save :clean_attrs
  
  file_column :image, :magick => {:geometry => "200x250>", :versions => {"profile" => "175x198>", "thumb" => "50x50>"}}
  
  validates_presence_of :ignite_id
  
  private
    def clear_event_key
      event.update_attribute(:organizer_id, nil)
    end
    
    def clean_attrs
    %w(bio email name).each do |attr|
      self.send("#{attr}=", ContentCleaner.clean(self.send(attr))) unless self.send(attr).nil?
    end

    ['company_url', 'personal_url', 'blog_url', 'twitter_url', 'linkedin_url'].each do |attr|
      self.send("#{attr}=", ContentCleaner.fix_link(self.send(attr))) unless self.send(attr).nil?
    end
  end
end
