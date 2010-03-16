class MoveProposalsClosedFromIgnitesToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :accepting_proposals, :boolean, :default => false
    Event.reset_column_information
    Ignite.all.each do |ignite|
      ignite.featured_event.update_attributes!(:accepting_proposals => !ignite.proposals_closed?)
    end
    remove_column :ignites, :proposals_closed
  end

  def self.down
    # eh
  end
end
