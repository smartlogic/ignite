class Article < ActiveRecord::Base
  has_many :comments, :as => :parent, :dependent => :destroy
  belongs_to :ignite
  
  validates_presence_of :ignite_id, :name
end
