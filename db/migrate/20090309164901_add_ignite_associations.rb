class AddIgniteAssociations < ActiveRecord::Migration
  def self.up
    [:events, :speakers, :organizers, :articles].each do |t|
      add_column t, :ignite_id, :integer
      add_index t, :ignite_id
      add_foreign_key t, :ignite_id, :ignites, :id
    end
  end

  def self.down
  end
end
