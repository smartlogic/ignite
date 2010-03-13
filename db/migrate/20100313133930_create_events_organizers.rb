class CreateEventsOrganizers < ActiveRecord::Migration
  def self.up
    create_table :events_organizers, :id => false do |t|
      t.integer :event_id
      t.integer :organizer_id
    end
    add_index :events_organizers, :event_id
    add_index :events_organizers, :organizer_id
    add_index :events_organizers, [:event_id, :organizer_id], :unique => true
    add_foreign_key :events_organizers, :event_id, :events, :id
    add_foreign_key :events_organizers, :organizer_id, :organizers, :id
    
    # Add every organizer to every event for their ignite
    Organizer.all.each do |organizer|
      organizer.ignite.events.each do |event|
        organizer.events << event
      end
    end
  end

  def self.down
    # eh
  end
end
