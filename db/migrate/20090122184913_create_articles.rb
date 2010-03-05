class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :name
      t.boolean :is_news, :default => false
      t.text :html_text
      t.boolean :is_sticky, :default => false
      t.boolean :comments_allowed, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
