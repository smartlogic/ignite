require File.dirname(__FILE__) + '/../test_helper'

class AdminTest < ActiveSupport::TestCase
  context "With a saved admin" do
    setup do
      @admin = Factory(:admin)
    end
    subject { @admin }
    should_validate_presence_of :login, :email
    
    context "when updating a non-password field" do
      setup do
        @admin.update_attributes!(:name => "Something else")
      end
      should_not_change("crypted password") { @admin.crypted_password }
      should_not_change("salt") { @admin.salt }
    end
    
    context 'when ignite_id is blank' do
      setup do
        @admin.ignite_id = nil
      end
      should 'be a superadmin' do
        assert @admin.superadmin?
      end
    end
    
    context 'when ignite_id is set' do
      setup do
        @admin.ignite = Factory(:ignite)
      end
      should 'not be a superadmin' do
        assert !@admin.superadmin?
      end
    end
  end
  
  context "With an unsaved admin" do
    setup do
      @admin = Factory.build(:admin)
    end
    should "require a password" do
      assert @admin.valid?, "Precondition failed"
      @admin.password = nil
      assert !@admin.valid?
    end
  end

  context '#authenticate' do
    setup do 
      @admin = Factory(:admin, :login => 'user', :password => 'passpass', :password_confirmation => 'passpass')
    end
    should 'succeed with correct password' do
      assert_equal @admin, Admin.authenticate('user', 'passpass')
    end
    should 'not succeed with incorrect password' do
      assert_nil Admin.authenticate('user', 'notpass')
    end
  end
  
  context 'remembering a login' do
    setup do
      @admin = Factory(:admin)
    end
    context 'on #remember_me' do
      setup do
        @admin.remember_me
      end
      should 'set token' do
        assert_not_nil @admin.remember_token
        assert_not_nil @admin.remember_token_expires_at
      end
      
      context 'on #forget_me' do
        setup do
          @admin.forget_me
        end
        should 'unset token' do
          assert_nil @admin.remember_token
        end
      end
    end
  end
end
