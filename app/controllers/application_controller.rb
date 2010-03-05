require 'rdiscount'
class ApplicationController < ActionController::Base
  include ReCaptcha::AppHelper
  include AuthenticatedSystem
  include ExceptionNotifiable
  
  helper :all # include all helpers, all the time
  
  $last_twitter_update = Time.now
  
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
    validate_recap(params, model.errors)
  end
  
end
