require 'exportable'
class Speaker < ActiveRecord::Base
  include AASM
  
  belongs_to :event
  has_many :comments, :as => :parent, :dependent => :destroy
  
  acts_as_list :scope => "event_id"
  file_column :image, :magick => {:versions => {"thumb" => "50x50>", "profile" => "180x250>"}}
  file_column :widget_image, :magick => {:geometry => "68x68", :versions => {"thumb" => "50x50>"}}
  file_column :mouseover_image, :magick => {:geometry => "68x68", :versions => {"thumb" => "50x50>"}}

  before_save :clean_attrs
  validates_presence_of :name, :title, :description, :bio, :event_id
    
  aasm_column :aasm_state
  aasm_state  :proposal, :display => 'Active Proposals'
  aasm_state  :archived, :display => 'Archived Proposals'
  aasm_state  :speaker,  :display => 'Speakers'
  aasm_initial_state :proposal
  
  aasm_event :archive do
    transitions :to => :archived, :from => :proposal
  end
  
  aasm_event :activate do
    transitions :to => :speaker, :from => [:archived, :proposal]
  end

  def status
    if self.archived?
      "Archived"
    elsif self.proposal?
      "Proposal"
    else
      "Speaker"
    end
  end
  
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
