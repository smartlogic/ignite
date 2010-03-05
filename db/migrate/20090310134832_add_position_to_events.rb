class AddPositionToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :position, :integer
  end

  def self.down
    remove_column :events, :position
  end
end
