class Speaker < ActiveRecord::Base
  include AASM
  
  belongs_to :event
  has_many :comments, :as => :parent, :dependent => :destroy

  validates_presence_of :name, :title, :description, :bio, :event_id
  
  acts_as_list :scope => "event_id"
  file_column :image, :magick => {:versions => {"thumb" => "50x50>", "profile" => "180x250>"}}
  file_column :widget_image, :magick => {:geometry => "68x68", :versions => {"thumb" => "50x50>"}}
  file_column :mouseover_image, :magick => {:geometry => "68x68", :versions => {"thumb" => "50x50>"}}
    
  aasm_column :aasm_state
  aasm_state  :proposal, :display => 'Active Proposals'
  aasm_state  :archived, :display => 'Archived Proposals'
  aasm_state  :speaker,  :display => 'Speakers'
  aasm_initial_state :proposal
  
  aasm_event :archive do
    transitions :from => :proposal, :to => :archived
  end
  
  aasm_event :unarchive do
    transitions :from => :archived, :to => :proposal
  end
  
  aasm_event :reconsider do
    transitions :from => :speaker, :to => :proposal
  end
  
  aasm_event :choose do
    transitions :from => :proposal, :to => :speaker
  end

  def to_param
    "#{id}-#{name.to_s.parameterize}"
  end
  
  def ignite
    event.ignite
  end

  # TODO : fix
  def status
    if self.archived?
      "Archived"
    elsif self.proposal?
      "Proposal"
    else
      "Speaker"
    end
  end
end
