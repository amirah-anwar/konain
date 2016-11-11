class AdminAbility
  include CanCan::Ability

  def initialize(user)

    if user.present?
      if user.admin?
        can :manage, :all
      elsif user.agent?
        can :manage, Page
        can :manage, Banner
        can :read, :all
        can :create, [Project]
        can :update, [Project]
        can :update, User, id: user.id
      end
    end
  end
end
