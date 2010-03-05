require 'exportable'
class Speaker < ActiveRecord::Base
  include AASM
  
  before_save :clean_attrs
  
  belongs_to :event
  belongs_to :ignite
  acts_as_list :scope => "event_id"
  has_many :comments, :as => :parent, :dependent => :destroy
  
  aasm_column :aasm_state
  aasm_state :active
  aasm_initial_state :active
  aasm_state :archived
  
  file_column :image, :magick => {:versions => {"thumb" => "50x50>", "profile" => "180x250>"}}
  file_column :widget_image, :magick => {:geometry => "68x68", :versions => {"thumb" => "50x50>"}}
  file_column :mouseover_image, :magick => {:geometry => "68x68", :versions => {"thumb" => "50x50>"}}
  
  validates_presence_of :name, :title, :description, :bio, :ignite_id
  
  def validate
    @errors.add(:event, "is not assigned to #{ignite.city}") if !event_id.nil? && event.ignite_id != self.ignite_id
  end
  
  named_scope :proposals, :conditions => {:event_id => nil}
  
  def export_columns(format=nil)
    %w[name title aasm_state ignite_id event_id description bio company_url personal_url blog_url twitter_url linkedin_url]
  end
  
  def social_links
    links = {}
    ['company_url', 'personal_url', 'blog_url', 'twitter_url', 'linkedin_url'].each do |link|
      unless(self.send(link).blank? || self.send(link).match(/^http:\/+$/))
        links[link.match(/^(\w+)_url/)[1].capitalize] = self.send(link)
      end
    end
    links
  end
  
  def is_proposal?
    event.nil?
  end
  
  def status
    if self.archived?
      "Archived"
    elsif self.event_id.blank?
      "Proposal"
    else
      "Active"
    end
  end
  
  aasm_event :archive do
    transitions :to => :archived, :from => :active
  end
  
  aasm_event :activate do
    transitions :to => :active, :from => :archived
  end
  
  private
  
  def clean_attrs
    %w(bio description email name title html_text).each do |attr|
      self.send("#{attr}=", ContentCleaner.clean(self.send(attr))) unless self.send(attr).nil?
    end

    ['company_url', 'personal_url', 'blog_url', 'twitter_url', 'linkedin_url'].each do |attr|
      self.send("#{attr}=", ContentCleaner.fix_link(self.send(attr))) unless self.send(attr).nil?
    end
  end
  
end
