class BaseUserController < ApplicationController
  layout 'user'
  before_filter :load_ignite
  
  private
    def load_ignite
      subdomain = current_subdomain =~ /^www\./ ? current_subdomain[4..-1] : current_subdomain
      @ignite = Ignite.find_by_domain(subdomain)
      if !@ignite
        render :status => 404, :text => "Could not find your Ignite site."
        return false
      end
      
      @current_event = @ignite.featured_event
      @sponsors = @current_event.sponsors
      @tweets = RssReader.get_ignite_feed(@ignite.twitter_username, @ignite.twitter_feed_url)
    end    
    
end
