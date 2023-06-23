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
      can :create, Transaction, user_id: user.id
    end

    return unless user&.type == 'Admin'

    can :manage, :all
  end
  # rubocop:enable Metrics/MethodLength
end
