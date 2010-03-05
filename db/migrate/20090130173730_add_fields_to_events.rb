class AddFieldsToEvents < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.boolean :is_complete, :null => false, :default => false
      t.string :summary_image
      t.string :sponsors_url
      t.string :videos_url
      t.string :images_url
      t.string :summary_image_caption
    end
  end

  def self.down
    change_table :events do |t|
      t.remove :is_complete
      t.remove :summary_image
      t.remove :sponsors_url
      t.remove :videos_url
      t.remove :images_url
      t.remove :summary_image_caption
    end
  end
end
