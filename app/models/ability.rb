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

    if user&.type == 'Merchant'
      can :index, Transaction
      can :create, Transaction, merchant_id: user.id
    end

    return unless user&.type == 'Admin'

    can :manage, Transaction
    can :manage, User, type: 'Merchant'
    can :manage, Merchant
  end
  # rubocop:enable Metrics/MethodLength
end
