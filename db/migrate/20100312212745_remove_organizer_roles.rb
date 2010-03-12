class RemoveOrganizerRoles < ActiveRecord::Migration
  def self.up
    remove_column :organizers, :organizer_role_id
    drop_table :organizer_roles
  end

  def self.down
    # eh
  end
end
