class AddEmbedUrlToSpeakers < ActiveRecord::Migration
  def self.up
    add_column :speakers, :video_embed_url, :string
  end

  def self.down
    remove_column :speakers, :video_embed_url
  end
end
