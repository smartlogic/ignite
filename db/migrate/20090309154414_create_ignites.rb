class CreateIgnites < ActiveRecord::Migration
  def self.up
    create_table :ignites do |t|
      t.string :city, :null => false
      t.string :logo_image
      t.string :banner_background_image
      t.string :banner_bottom_image
      t.string :twitter_username
      t.string :twitter_feed_url
      t.string :domain, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :ignites
  end
end
