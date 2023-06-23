# frozen_string_literal: true

class Ability
  include CanCan::Ability

  # rubocop:disable Metrics/MethodLength
  def initialize(user)
    if user.is_a? User
      can :destroy, :session
    else
      can %i[new create], :session
    end

    if user.is_a? Merchant
      can :index, Transaction
      can :create, Transaction, user:
    end

    return unless user.is_a? Admin

    can :manage, :all
  end
  # rubocop:enable Metrics/MethodLength
end
