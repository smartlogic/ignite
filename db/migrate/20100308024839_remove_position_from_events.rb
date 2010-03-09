class RemovePositionFromEvents < ActiveRecord::Migration
  def self.up
    remove_column :events, :position
  end

  def self.down
    # eh
  end
end
