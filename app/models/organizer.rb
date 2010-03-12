class Organizer < ActiveRecord::Base
  belongs_to :ignite
  
  before_save :clean_attrs
  
  file_column :image, :magick => {:geometry => "200x250>", :versions => {"profile" => "175x198>", "thumb" => "50x50>"}}
  
  validates_presence_of :ignite_id, :name
  
  attr_accessible :name, :bio, :email, :personal_url, :blog_url, :company_url, :twitter_url, :linkedin_url, :image
  
  private    
    def clean_attrs
    %w(bio email name).each do |attr|
      self.send("#{attr}=", ContentCleaner.clean(self.send(attr))) unless self.send(attr).nil?
    end

    ['company_url', 'personal_url', 'blog_url', 'twitter_url', 'linkedin_url'].each do |attr|
      self.send("#{attr}=", ContentCleaner.fix_link(self.send(attr))) unless self.send(attr).nil?
    end
  end
end
