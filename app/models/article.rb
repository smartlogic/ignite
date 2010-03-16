class Article < ActiveRecord::Base
  has_many :comments, :as => :parent, :dependent => :destroy
  belongs_to :ignite
  
  validates_presence_of :ignite_id, :name
  
  attr_protected :ignite_id
  
  named_scope :for_navigation, :conditions => {:show_in_navigation => true}
  
  def to_param
    "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
  end
end
