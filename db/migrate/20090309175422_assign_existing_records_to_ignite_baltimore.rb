class AssignExistingRecordsToIgniteBaltimore < ActiveRecord::Migration
  def self.up
    balto = Ignite.find_by_city("Baltimore")
    i = balto ? balto.id : Ignite.create!(:city => "Baltimore", :domain => "ignitebaltimore.com", :twitter_username => 'ignitebaltimore',
                   :twitter_feed_url => "http://twitter.com/statuses/user_timeline/15336208.rss",
                   :logo_image => File.new("public/images/layout/ignite-baltimore-logo.jpg"),
                   :banner_background_image => File.new("public/images/layout/ignite-baltimore-countdown-timer-background.jpg"),
                   :banner_bottom_image => File.new("public/images/layout/ignite-baltimore-banner-bottom.gif")).id
    [Event, Speaker, Organizer, Article].each do |klass|
      klass.update_all("ignite_id = #{i}", "ignite_id IS NULL")
    end
  end

  def self.down
  end
end
