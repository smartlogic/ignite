class AddKeyToSpeakers < ActiveRecord::Migration
  def self.up
    add_column :speakers, :key, :string, :limit => 30
    Speaker.all.each do |speaker|
      speaker.send(:generate_key)
      speaker.save!
    end
    add_index :speakers, :key, :unique => true
  end

  def self.down
    remove_column :speakers, :key
  end
end
