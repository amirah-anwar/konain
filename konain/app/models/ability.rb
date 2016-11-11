class Ability
  include CanCan::Ability

  def initialize(user)

    if user.present?
      if user.admin?
        can :manage, :all
      elsif user.agent?
        can :manage, Page
        can :read, :all
        can :update, User, id: user.id
        can [:agents, :lawyers, :architects], User
        can [:send_mail, :create, :contact, :send_contact_mail], Email
        can :create, [Project, Property]
        can :update, [Project, Property]
        can :destroy, Property
        can :property_types, Property
        can :read, ActiveAdmin::Page, name: "Dashboard"
      else
        can [:send_mail, :create, :contact, :send_contact_mail], Email
        can :read, [Property, Project, Page]
        can :manage, Property
        can [:update, :destroy], User, id: user.id
        can [:agents, :lawyers, :architects], User
        can :read, User, role: 'Agent'
        can :read, User, role: 'Lawyer'
        can :read, User, role: 'Architect'
        can :read, User, id: user.id
      end
    else
      can [:send_mail, :create, :contact, :send_contact_mail], Email
      can :read, [Property, Project, Page]
      can [:agents, :lawyers, :architects], User
      can :read, User, role: 'Agent'
      can :read, User, role: 'Lawyer'
      can :read, User, role: 'Architect'
      can :property_types, Property
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
