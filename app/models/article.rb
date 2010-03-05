class Article < ActiveRecord::Base
  has_many :comments, :as => :parent, :dependent => :destroy
  belongs_to :ignite
  
end
