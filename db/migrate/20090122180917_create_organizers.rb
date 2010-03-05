class CreateOrganizers < ActiveRecord::Migration
  def self.up
    create_table :organizers do |t|
      t.string :name
      t.text :bio
      t.string :email
      t.string :personal_url
      t.string :blog_url
      t.string :company_url
      t.string :twitter_url
      t.string :linkedin_url
      t.string :image
      t.integer :organizer_role_id

      t.timestamps
    end
      
    add_index :organizers, :organizer_role_id
    add_foreign_key :organizers, :organizer_role_id, :organizer_roles, :id
    
    #Update events table as well
    add_index :events, :organizer_id
    add_foreign_key :events, :organizer_id, :organizers, :id
  end

  def self.down
    remove_foreign_key :events, :events_ibfk_1
    drop_table :organizers
  end
end
