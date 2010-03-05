class Sponsor < ActiveRecord::Base
  include AASM
  
  aasm_column :aasm_state
  aasm_state :active
  aasm_initial_state :active
  aasm_state :inactive

  has_and_belongs_to_many :events
  
  file_column :image, :magick => {:versions => {"thumb" => "50x50>"}}
  
  aasm_event :activate do
    transitions :to => :active, :from => :inactive
  end
  
  aasm_event :deactivate do
    transitions :to => :inactive, :from => :active
  end
  
end
