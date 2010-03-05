# Exposes methods that create dev and test data. Loads things from a "user story"
# perspective.
class StoryHelper
  self.extend StoryAccessors::Methods

  def self.load_seed
    puts "Loading seed data..."
    load_admins
    load_ignites
    load_organizer_roles
    load_organizers
    load_events
    load_sponsors
    load_speakers
    load_seed_articles
  end

  def self.purge_seed
    # delete join table data
    [:events_sponsors].each do |table|
      ActiveRecord::Migration::execute "delete from #{table.to_s}"
    end
    
    [Speaker, Sponsor, Event, Organizer, Admin, OrganizerRole, Ignite].each do |klass|
      begin
        puts "Destroying #{klass}"
        klass.destroy_all
      rescue
        puts "Deleting #{klass}"
        klass.delete_all
      end
    end
  end

  def self.load_data
    puts "Loading story data..."
    load_proposals
    load_articles
  end
  
  def self.purge_data
    [Comment, Article].each do |klass|
      begin
        puts "Destroying #{klass}"
        klass.destroy_all
      rescue
        puts "Deleting #{klass}"
        klass.delete_all
      end
    end
  end
  
  def self.load_ignites
    Ignite.create!(:city => "Baltimore", :domain => "baltimore", :twitter_username => 'ignitebaltimore',
                   :twitter_feed_url => "http://twitter.com/statuses/user_timeline/15336208.rss",
                   :banner_background_image => public_file("/images/layout/ignite-baltimore-countdown-timer-background.jpg"),
                   :logo_image => public_file("/images/layout/ignite-baltimore-logo.jpg"),
                   :banner_bottom_image => public_file("/images/layout/ignite-baltimore-banner-bottom.gif"))
    Ignite.create!(:city => "DC", :domain => "dc", :twitter_username => "ignitedc",
                   :twitter_feed_url => "http://twitter.com/statuses/user_timeline/20239846.rss",
                   :banner_background_image => public_file("/images/layout/ignite-dc-countdown-timer-background.jpg"),
                   :logo_image => public_file("/images/layout/ignite-dc-logo.jpg"),
                   :banner_bottom_image => public_file("/images/layout/ignite-dc-banner-bottom.jpg"))
  end
  
  def self.load_sponsors
    Sponsor.create!(:name => "Technosailor", :link => "http://technosailor.com", :image => public_file("/images/sponsors/technosailor.jpg"))
    Sponsor.create!(:name => "Intridea", :link => "http://intridea.com/", :image => public_file("/images/sponsors/intridea.jpg"))
    Sponsor.create!(:name => "Event Rebels", :link => "http://eventrebels.com/", :image => public_file("/images/sponsors/event_rebels.jpg"))
    Sponsor.create!(:name => "Event", :link => "http://www.gbtechcouncil.org/", :image => public_file("/images/sponsors/gbtc.jpg"))
    Sponsor.create!(:name => "Mind Over Machines", :link => "http://www.mominc.com/", :image => public_file("/images/sponsors/mind_over_machines.jpg"))
    Sponsor.create!(:name => "Mindgrub", :link => "http://mindgrub.com/", :image => public_file("/images/sponsors/mindgrub.jpg"))
    Sponsor.create!(:name => "Daily Record", :link => "http://mddailyrecord.com/", :image => public_file("/images/sponsors/daily_record.jpg"))
    Event.all.each do |evt|
      evt.sponsors = Sponsor.all
    end
  end
  
  def self.load_organizer_roles
    OrganizerRole.create!(:title => "Founder")
    OrganizerRole.create!(:title => "Guest Organizer")
  end
  
  def self.load_organizers
    mikes_bio = "Mike Subelsky is co-founder and lead developer of OtherInbox.com, an Internet startup company based on open source technologies. In 2004 he helped found the Baltimore Improv Group and in 2007 helped found the Baltimore Improv Festival. He lives in Charles Village and works from home on a treadmill desk as a Ruby hacker, SproutCore enthusiast, improv theater director, and occasional blogger. He is a seven year veteran of the U.S. Navy and served in a variety of overseas and US-based assignments, including Operating ENDURING FREEDOM. "
    Organizer.create!(:organizer_role => founder, :name => "Mike Subelsky", :email => "", :image => dev_file("organizer_mike.jpg"), :personal_url => "",
                      :company_url => "http://otherinbox.com/", :twitter_url => "", :blog_url => "", :linkedin_url => "", :bio => mikes_bio, :ignite => baltimore)
    
    pattis_bio = "Patti Chan is co-founder, and creative & interactive director of 600block.com, a kick-ass social site for discovering Baltimore restaurants, bars, shopping, and more through the people who live here. She resides in Canton where she spends half her days in Photoshop, and the other half in Textmate conquering Ruby on Rails. When not perched in front of a computer, she can be seen around town doing “field research” on food and happy-hour specials for 600block. She also makes some mean eggrolls."
    Organizer.create!(:organizer_role => founder, :name => "Patti Chan", :email => "", :image => dev_file("organizer_patti.jpg"), :personal_url => "",
                      :company_url => "http://www.600block.com/", :twitter_url => "", :blog_url => "", :linkedin_url => "", :bio => pattis_bio, :ignite => baltimore)
    
    daves_bio = "Ignite #2 Organizer David Adewumi, Founder and Chief Storyteller of Heekya, leads the overall vision and product strategy for the start-up dubbed the ‘Wikipedia of Stories.’ For the past year, he has been contributing writer for VentureBeat.com, a high profile Silicon Valley technology and venture capital blog. Previously, he led sales & product development for Lomic, Inc. an oil & natural gas software firm. Mr. Adewumi has served in the US Army as an Airborne Infantryman, before being appointed to the US Military Academy at West Point. He attended the Pennsylvania State University, where he pursued a degree in Economics."
    Organizer.create!(:organizer_role => guest_organizer, :name => "David Adewumi", :email => "", :image => dev_file("organizer_david_adewumi.jpg"),
                      :personal_url => "", :company_url => "", :twitter_url => "", :blog_url => "", :linkedin_url => "", :bio => daves_bio, :ignite => baltimore)
    
    brents_bio = "Ignite #1 Organizer Brent Halliburton is the Senior Director of New Product Development for Advertising.com. He blogs at http://www.cogmap.com/blog/."
    Organizer.create!(:organizer_role => guest_organizer, :name => "Brent Halliburton", :email => "", :image => dev_file("organizer_brent.jpg"),
                      :personal_url => "", :company_url => "", :twitter_url => "", :blog_url => "http://www.cogmap.com/blog/", :linkedin_url => "", :ignite => baltimore, :bio => brents_bio)
  end
  
  def self.load_admins
    Admin.create!(:login => "pattichan", :name => "Patti Chan", :email => "pattichan@slsdev.net", :password => "pattichan", :password_confirmation => "pattichan")
    Admin.create!(:login => "subelsky", :name => "Mike Subelsky", :email => "subelsky@slsdev.net", :password => "subelsky", :password_confirmation => "subelsky")
    Admin.create!(:login => "ggentzke", :name => "Glenn Gentzke", :email => "ggentzke@slsdev.net", :password => "ggentzke", :password_confirmation => "ggentzke")
  end
  
  def self.load_events
    # ignite baltimore
    Event.create!({:name => "Ignite no. 1", :date => DateTime.parse("10/16/2008"), :ignite => baltimore, 
      :rsvp_url => "http://ignitebaltimore.eventbrite.com/", :description => "Ignite Baltimore number 1",
      :organizer => brent, :is_complete => true, :summary_image => dev_file("event_summary_image.jpg"),
      :summary_image_caption => "This is a picture caption."}.merge(windup_space))
    Event.create!({:name => "Ignite no. 2", :date => DateTime.parse("2/5/2009"), :ignite => baltimore, 
      :rsvp_url => "http://ignitebaltimore2.eventbrite.com/", :description => "Ignite Baltimore number 2",
      :organizer => david, :is_featured => true, :summary_image => dev_file("event_summary_image.jpg"),
      :summary_image_caption => "This is a picture caption."}.merge(windup_space))
    
    #ignite dc
    Event.create!({:name => "Ignite no. 1", :date => DateTime.parse("5/14/2009"), :ignite => dc, 
      :rsvp_url => "http://ignite-dc.com/", :description => "Ignite DC number 1",
      :summary_image => dev_file("event_summary_image.jpg"), :is_featured => true,
      :summary_image_caption => "This is a picture caption."}.merge(windup_space))
  end
  
  def self.load_speakers
    brian_desc = "An attempt to derive an equation for “good” and “evil” that relies on our most basic human attributes and not on the notion of “being” one or the other, since we are both."
    brian_bio = "Brian is a serial entrepreneur, activist and in his words, “one of the masses”."
    Speaker.create!(:name => "Brian Le Gette", :title => "Monkeys, Magic Forces & Evil", :description => brian_desc, :bio => brian_bio, :personal_url => "",
                    :blog_url => "", :event => ignite2, :image => dev_file("no_photo.jpg"), :ignite => baltimore)
    
    bruce_desc = "Didn’t make it into Business Week’s ‘Top Young Entrepreneurs’? Learn how to succeed in the corporate machine as a 20Something."
    bruce_bio = <<-BIO
    As a 25 year old who will now never be featured on an ‘Under 25 Top Entrepreneurs’ list, Bruce still has found success working for “The Man”.
Bruce has been invited to speak at Fannie Mae, Freddie Mac, IIBA DC (International Institute of Business Analysis) , IIBA Baltimore, University of Maryland (upcoming). Talks with the PMI (Project Management Institute) about speaking at their Region 5 Leadership Conference are taking place as well.
Bruce has been published in the August Issue of Mortgage Banking Magazine, and is currently co-authoring another article with the CEO of the company.

Bruce is employed at a boutique consulting company called CC Pace, and used to work for American Management Systems. He also blogs at 20somethingsuccess.com.
    BIO
    Speaker.create!(:name => "Bruce Yang", :title => "Not Listed in ‘25 under 25′: Succeeding in the corporate world for the rest of us", :image => dev_file("no_photo.jpg"),
                    :description => bruce_desc, :ignite => baltimore, :bio => bruce_bio, :personal_url => "", :blog_url => "http://www.20somethingsuccess.com/", :event => ignite2)
    
    caleb_desc = "In an mp3 age, with every second of recorded music at our fingertips, the archaic concept of an ‘album’ seems more interesting than ever."
    caleb_bio = "Caleb Stine plays Rhythm & Blue-Collar Music. He has just released a CD of collaborations with the Baltimore rapper Saleem, is currently recording a gritty solo album, and has a Caleb Stine & The Brakemen live DVD in the works."
    Speaker.create!(:name => "Caleb Stine", :title => "My 10 Favorite Albums", :description => caleb_desc, :bio => caleb_bio, :personal_url => "",
                    :blog_url => "", :event => ignite2, :image => dev_file("no_photo.jpg"), :ignite => baltimore)
    
    chris_desc = "From literally writing the business plan on back of a napkin to building a skeleton prototype and being rejected by every VC, rebuilding the product and finally launching and reversing the table on investors as they now come to us. I’ll briefly discuss the road, why it’s so hard, what it takes to survive the first year (during an economic depression) and how we plan to continue growing."
    chris_bio = "Chris is an entrepreneur with over 12 years experience starting and launching technology companies. Chris is in charge of strategic partnerships, distribution and marketing for DubMeNow. Prior to DubMeNow, Chris was the founder and president of TaxScan Technologies, a tax software company incorporating OCR technology and is a former managing partner at Frontier Tax & Accounting."
    s = Speaker.create!(:name => "Chris Hopkinson", :title => "I survived my first year as web 2.0 company", :description => chris_desc,
                    :bio => chris_bio, :personal_url => "", :blog_url => "", :event => ignite2, :image => dev_file("no_photo.jpg"), :ignite => baltimore)
    s.comments << Comment.create!(:author => "bob", :email => "bob@slsdev.net", :url => "www.google.com", :content => "im commenting so much")
  end
  
  def self.load_proposals
    p = Speaker.create!(:name => "Pro McPosal", :title => "How to Avoid Being Assigned to an Event", :description => "I'll tell you how to avoid becoming a speaker.",
                    :bio => "Pro spent his life being insignificant.", :personal_url => "", :blog_url => "", :image => dev_file("no_photo.jpg"), :ignite => baltimore)
    p.comments << Comment.create!(:author => "glenn", :email => "glenn@slsdev.net", :url => "www.google.com", :content => "This proposal sounds fantastic!")
  end
  
  def self.load_seed_articles
    #regular articles
    Article.create!(:name => "About", :ignite => baltimore, :html_text => "<h2>About Ignite</h2>
<p><strong>Five minutes, 20 slides. What would you say?</strong> At every Ignite, 16 artists, technologists, thinkers, and personalities will take the stage to answer this challenge.</p>
<p>Ignite was started in Seattle in 2006 by Brady Forrest and Bre Pettis. Since then 100s of 5 minute talks have been given across the world. There are thriving Ignite communities in Seattle, Portland, Paris, and now, <strong>right here in Baltimore!</strong></p>")
    
    affiliates_content = <<-HTML
      <ul>
        <li>
          <a href="http://radarredux.net/"><strong>RADARREDUX</strong></a><br />
          Ignite Baltimore presentations are webcast live and recorded by RADARREDUX. RADARREDUX is a project of the Greater Baltimore Cultural Alliance, in partnership with the Maryland Institute College of Art and Johns Hopkins University.
        </li>
        <li>
          <a href="http://barcamp.org/SocialDevCampEast"><strong>SocialDevCampEast</strong></a><br />
          SocialDevCamp East is the Unconference for Thought Leaders of the Future Social Web
        </li>
        <li>
          <a href="http://www.refreshbmore.org"><strong>Refresh Bmore</strong></a><br />
          Refresh Baltimore is invigorating the creative, technical, and professional culture of emerging media ventures in the Baltimore Metro Area.
        </li>
        <li>
          <a href="http://www.stoopstorytelling.com"><strong>Stoop Storytelling Series</strong></a><br />
          Each Stoop show features seven storytellers who get seven minutes each to tell a true, personal story about a specific theme.
        </li>
      </ul>
    HTML
    Article.create!(:name => "Affiliates", :html_text => affiliates_content, :ignite => baltimore)
    Article.create!(:name => "Sponsor Ignite", :html_text => affiliates_content, :ignite => baltimore)
    Article.create!(:name => "Proposal Submitted", :ignite => baltimore, :html_text => "<h2>Thank you for your submission!</h2><p>You will be contacted by email when your submission has been reviewed.</p>", :comments_allowed => false)
  end
  
  def self.load_articles
    #new articles
    speaker_content = <<-HTML
      <p>Here are the speakers and topics for Ignite Baltimore #2, taking place on February 5th at 6 pm:</p>
      <ul>
      <li><a href="#01">Councilman Bill Henry</a> (pictured) - Civic Engagement</li>
      <li><a href="#02">Brian Le Gette</a> - Monkeys, Magic Forces &amp; Evil</li>
      <li><a href="#03">Bruce Yang</a> - Not Listed in &#8216;25 under 25&#8242;: Succeeding in the corporate world for the rest of us</li>
      
      <li><a href="#04">Caleb Stine</a> - My 10 Favorite Albums</li>
      <li><a href="#05">Chris Hopkinson</a> - I survived my first year as web 2.0 company</li>
      <li><a href="#06">Debra Rubino</a> - TBA</li>
      <li><a href="#07">Ethel Weld, MD</a> - The monkeyfish within us</li>
      <li><a href="#08">Heather Kirk-Davidoff</a> - More Than Rules: Five Ways to Really Choose Civility</li>
      <li><a href="#09">Jared Goralnick</a> - A Little Bit of Productivity for a Great Bit of Happiness</li>
      
      <li><a href="#10">Julie E. Gabrielli, NCARB, LEED</a> - The Silver (Green) Lining</li>
      <li><a href="#11">Kelly Keenan Trumpbour</a> - Running Start</li>
      <li><a href="#12">Lee Boot</a> - Art can save the world. No, really.</li>
      <li><a href="#13">Mario Armstrong</a> - The Brand as You</li>
      <li><a href="#14">Neal Shaffer</a> - Business Lessons I Learned Growing Up in the DIY/Punk Culture</li>
      <li><a href="#15">Patti Chan</a> - That&#8217;s Ugly! 20 Steps to a More Beautiful Web</li>
      
      <li><a href="#16">Todd Marks</a> - Social Media and Location Based Services</li>
      </ul>
    HTML
    a = Article.create!(:name => "Speakers for Ignite Baltimore #2", :html_text => speaker_content, :is_news => true, :ignite => baltimore)
    a.comments << Comment.create!(:author => "glenn", :email => "glenn@slsdev.net", :url => "www.google.com", :content => "im commenting so much")
    
    how_to_content = <<-HTML
    <p>We are excited that Ignite #2 has completely sold-out.  Here&#8217;s how to make sure you can gain entry to the event:</p>
<p><strong>If You Have a Ticket</strong></p>
<p>Please plan to arrive at The Windup Space by 6:30 pm.  We will only be honoring RSVPs until 6:45 pm, after which time we&#8217;ll open the doors to the public.</p>
<p><strong>If You Don&#8217;t Have a Ticket</strong></p>
<p>Don&#8217;t worry, there&#8217;s still a good chance you can get in.  Some people RSVP but don&#8217;t show up (because it&#8217;s a free event, after all).  Plan to arrive around 6 pm and we&#8217;ll put your name on a waiting list.  Then you can head over to Joe Squared pizza, or down Charles Street to one of the hang-out spots, and plan to come back by 6:45 pm.</p>
    HTML
    Article.create!(:name => "How to get into Ignite #2", :html_text => how_to_content, :is_news => true, :ignite => baltimore)
    Article.create!(:name => "Comments Banned From Certain Articles Due to Online Mischief", :ignite => baltimore, :html_text => "<p>I told you we would ban comments if we had to.  Now you can't post.</p>", :is_news => true, :comments_allowed => false)
    
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
  end

  
  
  private
    def self.windup_space
      {:location_name => "The Windup Space", :address_line1 => "12 W. North Ave.", :city => "Baltimore", :state => "MD", :zip => "21201",
       :map_url => "http://maps.google.com/maps?f=q&hl=en&geocode=&q=10-12+w.+north+ave,+baltimore,+md+21201&sll=39.311996,-76.615992&sspn=0.005313,0.008723&ie=UTF8&s=AARTsJp_lsVFWH4GuqqPKYEFbyuh7T5-og&view=map"}
    end
    
    def self.dev_file file
      File.new File.join(RAILS_ROOT, 'test', 'dev_images', file)
    end
    
    def self.public_file file
      File.new File.join(RAILS_ROOT, 'public', file)
    end
end