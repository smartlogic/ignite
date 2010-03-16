class RemoveOrganizerIdFromEvents < ActiveRecord::Migration
  def self.up
    remove_column :events, :organizer_id
  end

  def self.down
  end
end
