class UpdateSeedData < ActiveRecord::Migration
  def self.up
    # Create all the sponsors and associate them with ignite baltimore
    Sponsor.create!(:name => "Technosailor", :link => "http://technosailor.com", :image => File.new("public/images/sponsors/technosailor.jpg"))
    Sponsor.create!(:name => "Intridea", :link => "http://intridea.com/", :image => File.new("public/images/sponsors/intridea.jpg"))
    Sponsor.create!(:name => "Event Rebels", :link => "http://eventrebels.com/", :image => File.new("public/images/sponsors/event_rebels.jpg"))
    Sponsor.create!(:name => "Event", :link => "http://www.gbtechcouncil.org/", :image => File.new("public/images/sponsors/gbtc.jpg"))
    Sponsor.create!(:name => "Mind Over Machines", :link => "http://www.mominc.com/", :image => File.new("public/images/sponsors/mind_over_machines.jpg"))
    Sponsor.create!(:name => "Mindgrub", :link => "http://mindgrub.com/", :image => File.new("public/images/sponsors/mindgrub.jpg"))
    Sponsor.create!(:name => "Daily Record", :link => "http://mddailyrecord.com/", :image => File.new("public/images/sponsors/daily_record.jpg"))
    baltimore = Ignite.find_by_city("Baltimore")
    baltimore.events.each do |evt|
      evt.sponsors = Sponsor.all
    end
    
    # This adds in the article snippits for the baltimore ignite needed in events show, index, and past
    Article.create!(:name => "PastEventsDescription", :html_text => "<p>Ignite Baltimore presentations are webcast live and recorded by RADARREDUX. <strong>After each Ignite, links to the speakers, sponsors, and recorded videos will be posted here.</strong></p>",
                    :ignite => baltimore)
    Article.create!(:name => "EventsIndexDescription", :html_text => "<p>Ignite Baltimore presentations are webcast live and recorded by RADARREDUX. <strong>After each Ignite, links to the speakers, sponsors, and recorded videos will be posted here.</strong></p>",
                    :ignite => baltimore)
    
get_involved_info = <<-HTML
<h3>Get Involved</h3>
<ul>
  <li><a href="http://twitter.com/ignitebaltimore/">Follow Us on Twitter</a></li>
  <li><%= link_to 'Submit a Proposal', new_proposal_url %></li>
  <li><a href="mailto:sponsors@ignitebaltimore.com">Email to Become a Sponsor</a></li>
  <li><a href="http://feeds.feedburner.com/ignite_baltimore">Subscribe to the RSS Feed</a></li>
</ul>
HTML

    Article.create!(:name => "GetInvolvedInfo", :html_text => get_involved_info, :ignite => baltimore)
    
org_desc = %q(<p>Ignite is brought to you by organizers <%= link_to 'Mike Subelsky', "##{@fanchors.index(@founders[0])}" %> and <%= link_to 'Patti Chan', "##{@fanchors.index(@founders[1])}" %>, plus a special guest organizer for each event. Would you like to help organize a future Ignite event? Contact us for more details!</p>)
    Article.create!(:name => "OrganizerIndexDescription", :ignite => baltimore, :html_text => org_desc)
    
    #Create an Ignite for DC
    dc = Ignite.find_by_city("DC")
    unless dc
      dc = Ignite.create!(:city => "DC", :domain => "ignite-dc.com", :twitter_username => "ignitedc",
        :twitter_feed_url => "http://twitter.com/statuses/user_timeline/20239846.rss",
        :logo_image => File.new("public/images/layout/ignite-dc-logo.jpg"),
        :banner_background_image => File.new("public/images/layout/ignite-dc-countdown-timer-background.jpg"),
        :banner_bottom_image => File.new("public/images/layout/ignite-dc-banner-bottom.jpg"))
    
      #Create a featured event for DC
      dc.events << Event.create!(:name => "Ignite no. 1", :date => DateTime.parse("5/14/2009"), :ignite => dc, 
        :rsvp_url => "http://ignite-dc.com/", :description => "Ignite DC number 1", :is_featured => true,
        :location_name => "The Windup Space", :address_line1 => "12 W. North Ave.", :city => "Baltimore", :state => "MD", :zip => "21201",
        :map_url => "http://maps.google.com/maps?f=q&hl=en&geocode=&q=10-12+w.+north+ave,+baltimore,+md+21201")
    end
  end

  def self.down
  end
end
