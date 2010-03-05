class CreateEventsSponsors < ActiveRecord::Migration
  def self.up
    create_table :events_sponsors, :id => false do |t|
      t.integer :event_id, :null => false
      t.integer :sponsor_id, :null => false
    end
    
    add_index :events_sponsors, [:event_id, :sponsor_id], :uniq => true
    add_index :events_sponsors, :event_id
    
    add_foreign_key :events_sponsors, :event_id, :events, :id
    add_foreign_key :events_sponsors, :sponsor_id, :sponsors, :id
    
  end

  def self.down
    drop_table :events_sponsors
  end
end
