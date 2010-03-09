class Admin::BaseAdminController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :load_ignite
end