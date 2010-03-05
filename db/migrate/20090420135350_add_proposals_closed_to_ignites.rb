class AddProposalsClosedToIgnites < ActiveRecord::Migration
  def self.up
    change_table :ignites do |t|
      t.boolean :proposals_closed, :default => false
    end
  end

  def self.down
    change_table :ignites do |t|
      t.remove :proposals_closed
    end
  end
end
