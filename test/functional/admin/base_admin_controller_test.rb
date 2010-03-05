require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/base_admin_controller'

# Re-raise errors caught by the controller.
class Admin::BaseAdminController; def rescue_action(e) raise e end; end

class Admin::BaseAdminControllerTest < ActionController::TestCase
  test "the truth" do
    assert true
  end
end
