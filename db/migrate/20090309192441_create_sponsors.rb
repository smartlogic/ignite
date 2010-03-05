class CreateSponsors < ActiveRecord::Migration
  def self.up
    create_table :sponsors do |t|
      t.string :name
      t.string :link
      t.string :image
      t.string :aasm_state
    end
  end

  def self.down
    drop_table :sponsors
  end
end
