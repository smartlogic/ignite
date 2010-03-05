require 'rss/2.0'
require 'open-uri'

class RssReader
  DEFAULT_URL = "http://twitter.com/statuses/user_timeline/15336208.rss"
  DEFAULT_USERNAME = "ignitebaltimore"
  RELOAD_INTERVAL = 60.seconds

  @@last_twitter_update = {}
  @@tweets = {}
  Ignite.all.map(&:twitter_username).each do |acct|
    @@last_twitter_update[acct] = Time.now
    @@tweets[acct] = []
  end

  def self.gimme_tweets(feed_url, length, perform_validation=false)
    tweets = []
    open(feed_url) do |rss|
      tweets = RSS::Parser.parse(rss, perform_validation).items
    end
    return (tweets.size > length) ? tweets[0..length - 1] : tweets 
  end
  
  def self.get_formatted_tweets(user, url, limit=2)
    tweets = []
    unless RAILS_ENV == "test"
      fetcher = Thread.new do
        tweets = RssReader.gimme_tweets(url, limit)
      end
      waiter = Thread.new do
        sleep(4)
      end
      while (waiter.status == 'sleep')
        if fetcher.status == false
          waiter.kill
          fetcher.join
        end
        sleep(0.2)
      end
      if waiter.status == false
        waiter.join
        fetcher.kill
      end
    end
    
    now = Time.now.to_i
    formatted_tweets = []
    tweets.each do |tweet|
      desc = tweet.description
      time_diff = now - Time.parse(tweet.pubDate.to_s).to_i
      tweeted = ""
      case
        when time_diff < 60 :
          tweeted = time_diff.to_s + " seconds ago"
        when time_diff < 3600 :
          tweeted = "about " + (time_diff/60).floor.to_s + " minutes ago"
        when time_diff < 7200 :
          tweeted = "about 1 hour ago"
        when time_diff < 86400 :
          tweeted = "about " + (time_diff/3600).floor.to_s + " hours ago"
        when time_diff < 172800 :
          tweeted = "about 1 day ago"
      else
        tweeted = (time_diff/86400).floor.to_s + " days ago"
      end

      desc.sub!(user + ": ", '')
      desc.gsub!(/(http:\/\/)(.*?)\/([\w\.\/\&\=\?\-\,\:\;\#\_\~\%\+]*)/, "<a href=\"\\0\">Link</a>")
      desc.gsub!(/@([a-zA-Z0-9\_]+)/, "<a href=\"http://www.twitter.com/\\1\">\\0</a>")
      
      formatted_tweets << {:content => desc, :timestamp => tweeted}
    end
    return formatted_tweets
  end
  
  def self.get_ignite_feed(user, url)
    if ((Time.now - @@last_twitter_update[user]) > RELOAD_INTERVAL || @@tweets[user].empty?)
      @@tweets[user] = RssReader.get_formatted_tweets(user, url)
      @@last_twitter_update[user] = Time.now
    end
    unless @@tweets[user].empty?
      return @@tweets[user]
    else
      return [{:content => "Twitter feed unavailable.", :timestamp => ""}]
    end
  rescue
    unless @@tweets[user].nil? || @@tweets[user].empty?
      return @@tweets[user]
    else
      return [{:content => "Twitter feed unavailable.", :timestamp => ""}]
    end
  end


end
