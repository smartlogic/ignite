class CreateOrganizerRoles < ActiveRecord::Migration
  def self.up
    create_table :organizer_roles do |t|
      t.string :title
    end
  end

  def self.down
    drop_table :organizer_roles
  end
end
