class Article < ActiveRecord::Base
  has_many :comments, :as => :parent, :dependent => :destroy
  belongs_to :ignite
  
  validates_presence_of :ignite_id, :name
  
  attr_protected :ignite_id

  before_save :ensure_only_one_article_sticky
  
  named_scope :for_navigation, :conditions => {:show_in_navigation => true}
  named_scope :sticky, :conditions => {:is_sticky => true}
  
  def to_param
    "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
  end
  
  private
    def ensure_only_one_article_sticky
      if self.is_sticky?
        self.ignite.articles.update_all("is_sticky = 0")
      end
    end
  
end
