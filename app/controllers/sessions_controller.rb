# This controller handles the login/logout function of the site.  
class SessionsController < BaseUserController

  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!
    admin = Admin.authenticate(params[:login], params[:password])
    if admin
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_admin = admin
      handle_remember_cookie! false
      redirect_back_or_default(admin_url)
      flash[:notice] = "Logged in successfully"
    else
      note_failed_signin
      @login       = params[:login]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
