class CreateSpeakers < ActiveRecord::Migration
  def self.up
    create_table :speakers do |t|
      t.string :name
      t.string :title
      t.text :description
      t.text :bio
      t.string :email
      t.integer :event_id
      t.string :blog_url
      t.string :twitter_url
      t.string :linkedin_url
      t.string :personal_url
      t.string :company_url
      t.string :video_url
      t.integer :postion
      t.text :html_text
      t.string :image
      t.string :mouseover_image
      t.string :aasm_state

      t.timestamps
    end
    
    add_index :speakers, :event_id
    add_foreign_key :speakers, :event_id, :events, :id
  end

  def self.down
    drop_table :speakers
  end
end
