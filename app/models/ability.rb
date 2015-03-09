class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user

    if user.role?(:admin)
      can :manage, :all
    else

      can :read, Review
      can [:show, :create, :update], Search
      can [:telefone, :site, :mapa, :ler_mais, :show], Vendor
      can :create, Track
      can :accepted_invitation, User
      can [:create, :cadastro] , Message

      if user.role?(:user) || user.role?(:tester)
        can [:create, :vendors], Proposal
        can [:widget, :rate, :user_request_proposal, :user_first_proposal], Vendor
        can :create, Quotation
        can [:create, :cadastro, :atualizacao], Message
        can [:show, :create], Review
        can :create, Appointment
        can :create, Bookmark
        can :create_invitation, User
        can [:show,:update], User do |current_user|
          current_user.try(:id) == user.id
        end
        can [:update, :destroy], Review do |review|
          review.try(:user) == user
        end
        can [:update, :destroy], Bookmark do |b|
          b.try(:user) == user
        end
        
        if user.role?(:tester)
          can :read, Dress
        end
      end

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
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
