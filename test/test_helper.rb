ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'will_paginate'
require 'shoulda'

class Test::Unit::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #fixtures :all
  #fixtures []

  # Add more helper methods to be used by all tests here...
  include StoryAccessors::Methods
end


module ActionController
  class TestCase
    
    # allows us to use the self.log_in function to log in a certain user
    @@scoped_session = {}
    @@scoped_user    = nil
          
    def setup
      log_out
      set_host(baltimore)
    end
    
    # Used within a test to log in a specific user for a single test
    def log_in(user)
      old_scoped_user = @@scoped_user
      @@scoped_user = user
      yield
    ensure
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
