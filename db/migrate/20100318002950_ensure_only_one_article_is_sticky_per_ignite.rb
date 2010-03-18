class EnsureOnlyOneArticleIsStickyPerIgnite < ActiveRecord::Migration
  def self.up
    Ignite.all.each do |ignite|
      articles = ignite.articles.sticky.find(:all, :order => 'created_at DESC')
      articles.shift
      articles.each do |a|
        a.update_attribute(:is_sticky, false)
      end
    end
  end

  def self.down
    # eh
  end
end
