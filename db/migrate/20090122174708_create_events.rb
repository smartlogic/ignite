class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name, :null => false
      t.datetime :date, :null => false
      t.string :location_name
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :state
      t.string :zip
      t.boolean :is_featured, :default => false
      t.string :rsvp_url
      t.string :map_url
      t.text :description
      t.integer :organizer_id, :null => true

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
