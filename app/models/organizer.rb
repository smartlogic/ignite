class Organizer < ActiveRecord::Base
  belongs_to :ignite
  has_and_belongs_to_many :events
  
  file_column :image, :magick => {:geometry => "200x250>", :versions => {"profile" => "175x198>", "thumb" => "50x50>"}}
  
  validates_presence_of :ignite_id, :name
  
  attr_accessible :name, :bio, :email, :personal_url, :blog_url, :company_url, :twitter_url, :linkedin_url, :image, :event_ids
  
end
