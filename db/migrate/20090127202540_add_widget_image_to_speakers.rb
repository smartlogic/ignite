class AddWidgetImageToSpeakers < ActiveRecord::Migration
  def self.up
    add_column :speakers, :widget_image, :string
  end

  def self.down
    remove_column :speakers, :widget_image
  end
end
