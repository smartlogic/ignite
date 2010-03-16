require File.dirname(__FILE__) + '/../test_helper'

class AbilityTest < ActiveSupport::TestCase
  context "An admin" do
    setup do
      @admin = Factory(:admin)
      @ability = Ability.new(@admin)
    end
    
    # Ignite
    should 'manage their own ignite' do
      assert @ability.can?(:manage, @admin.ignite)
    end
    should 'not manage another ignite' do
      assert @ability.cannot?(:manage, Factory(:ignite))
    end
    
    # Admin
    should 'edit another admin for their ignite' do
      assert @ability.can?(:manage, Factory(:admin, :ignite => @admin.ignite))
    end
    should 'not edit another admin from a different ignite' do
      assert @ability.cannot?(:manage, Factory(:admin))
    end
    should 'not edit a superuser' do
      assert @ability.cannot?(:manage, Factory(:superadmin))
    end
    should 'not remove themselves' do
      assert @ability.cannot?(:destroy, @admin)
    end
    
    # Event
    should 'edit an event for their ignite' do
      assert @ability.can?(:manage, Factory(:event, :ignite => @admin.ignite))
    end
    should 'not edit an event for another ignite' do
      assert @ability.cannot?(:manage, Factory(:event))
    end
    
    # Organizer
    should 'edit an organizer for their ignite' do
      assert @ability.can?(:manage, Factory(:organizer, :ignite => @admin.ignite))
    end
    should 'not edit an organizer for another ignite' do
      assert @ability.cannot?(:manage, Factory(:organizer))
    end
        
    # Article
    context "" do
      setup do
        @article = Factory.build(:article)
      end
      should 'edit an article for their ignite' do
        @article.ignite = @admin.ignite
        assert @ability.can?(:manage, @article)
      end
      should 'not edit an article for another ignite' do
        @article.ignite = Factory(:ignite)
        assert @ability.cannot?(:manage, @article)
      end
    end
  end
  
  context "A superadmin" do
    setup do
      @superadmin = Factory(:superadmin)
      @ability = Ability.new(@superadmin)
    end

    # Admin
    should "manage another superadmin" do
      assert @ability.can?(:manage, Factory(:superadmin))
    end
    should "manage admins" do
      assert @ability.can?(:manage, Factory(:admin))
    end
    should "not remove themselves" do
      assert @ability.cannot?(:destroy, @superadmin)
    end
    
    [Ignite, Event, Organizer, Speaker].each do |klass|
      should "manage #{klass.to_s.pluralize}" do
        assert @ability.can?(:manage, Factory(klass.to_s.underscore))
      end
    end
    
    should "manage an Article" do
      article = Factory.build(:article)
      article.ignite = Factory(:ignite)
      assert @ability.can?(:manage, article)
    end
  end
end
