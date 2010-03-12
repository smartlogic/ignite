ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'will_paginate'

require 'shoulda'
require 'factory_girl'
Dir.glob(File.join(RAILS_ROOT, 'test', 'factories', '**/*.rb')).each{|f| require f}

def test_lib(file)
  File.join(File.dirname(__FILE__), 'lib', file)
end

require test_lib('assertions')
require test_lib('shoulda_ext')

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  # Add more helper methods to be used by all tests here...
  extend Shoulda::IgniteMacros
end

module ActionController
  class TestCase
    include IgniteAssertions
    
    # allows us to use the self.log_in function to log in a certain user
    @@scoped_session = {}
    @@scoped_user    = nil
          
    def setup
      log_out
    end
    
    # Used within a test to log in a specific user for a single test
    def log_in(user)
      old_scoped_user = @@scoped_user
      @@scoped_user = user
      return if !block_given?
      yield
      @@scoped_user = old_scoped_user
    end
    
    def log_out
      @@scoped_session = {}
      @@scoped_user = nil
    end
    
    [:get, :post, :put, :delete].each do |meth|
      src = <<-END_OF_SRC
        def #{meth.to_s}(action, parameters = nil, session = {}, flash = nil)
    	    log_in_scoped_user
    	    super(action, parameters, session.merge(@@scoped_session || {}), flash)
    	  end
    	END_OF_SRC
      class_eval src, __FILE__, __LINE__
    end
    	
	  def xhr(request_method, action, parameters = nil, session = {}, flash = nil)
	    log_in_scoped_user
	    super(request_method, action, parameters, session.merge(@@scoped_session || {}), flash)
	  end
	      	
	  protected
	    def set_host(ignite)
	      if ignite.is_a?(Ignite)
          @request.host = ignite.domain + '.com'
        else
          @request.host = ignite
        end
      end

    private
	    def log_in_scoped_user
	      if !@@scoped_user.nil?
	        @@scoped_session[:admin_id] = @@scoped_user.id
	      end
	    end	    
  end
end
