require 'rdiscount'
class ApplicationController < ActionController::Base
  include Recaptcha::Verify
  include AuthenticatedSystem
  include ExceptionNotifiable
  
  helper :all # include all helpers, all the time
  
  $last_twitter_update = Time.now
    
  protected
    def load_ignite
      subdomain = current_subdomain =~ /^www\./ ? current_subdomain[4..-1] : current_subdomain
      @ignite = Ignite.find_by_domain(subdomain)
      if !@ignite
        render :status => 404, :text => "Could not find an Ignite site at #{subdomain}"
        return false
      end
      
      @current_event = @ignite.featured_event
      @sponsors = @current_event.sponsors
      @tweets = RssReader.get_ignite_feed(@ignite.twitter_username, @ignite.twitter_feed_url)
    end    
  
    # to be used as an around_filter for those controllers that need/want to log to the transaction log
    def load_transaction_logger
      tlogfile = File.open(File.join(RAILS_ROOT, 'log', 'transactions.log'), 'a')
      @tlogger = TransactionLogger.new(tlogfile)
      yield
      tlogfile.flush
      tlogfile.close
    end

    def tlog(severity, msg)
      full_msg = "\nRequesting ip: #{request.remote_ip}\n\t#{msg}"
      @tlogger.send(severity, msg)
    rescue
      @tlogger.send(severity, msg)
    end

    def validate_captcha(params, model)
      return true if Rails.env.test? || Rails.env.development?
      verify_recaptcha(params.merge({:model => model}))
    end
    
    # [CanCan] override default of current_user
    def current_ability
      Ability.new(current_admin)
    end
end
