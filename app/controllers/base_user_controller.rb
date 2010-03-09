class BaseUserController < ApplicationController
  layout 'user'
  before_filter :load_ignite
end
