class Admin::BaseAdminController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :load_ignite
  
  rescue_from 'CanCan::AccessDenied' do |exception|
    render :status => 403, :file => 'public/403.html'
  end
end