class Admin::BaseAdminController < ApplicationController
  layout 'admin'
  
  before_filter :login_required
  
end