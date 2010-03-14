require 'cancan'
class Ability
  include ::CanCan::Ability

  def initialize(this_user)
    can :manage, :all
    if this_user.superadmin?
      cannot :destroy, Admin do |admin|
        admin == this_user
      end
    else
      cannot :manage, Ignite do |action, ignite|
        ignite != this_user.ignite
      end

      cannot :manage, Admin do |action, admin|
        admin.superadmin? ||                        # if he's a superadmin
          admin.ignite != this_user.ignite ||       # or he belongs to a different ignite
          admin == this_user && action == :destroy  # or we're trying to destroy ourself
      end
      
      cannot :manage, [Event, Organizer, Article] do |action, obj|
        obj.ignite != this_user.ignite
      end
    end
  end
end