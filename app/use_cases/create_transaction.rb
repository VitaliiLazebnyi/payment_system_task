# frozen_string_literal: true

class CreateTransaction
  include UseCase

  attr_reader :user, :params, :success, :transaction

  def initialize(user, params)
    @user = user
    @params = params
  end

  def perform
    # Validate parameters
    validate_merchant_id
    validate_transaction_type

    # calls proper transaction creation
    create_transaction
  end

  private

  def validate_merchant_id
    return true if user.id == params[:merchant_id]

    raise ArgumentError, 'Merchant_id should be the same as current_user.id'
  end

  def validate_transaction_type
    return if Transaction::CLASSES.include?(params[:type])

    raise ArgumentError, 'invalid transaction type'
  end

  def create_transaction
    use_case = "Create#{params[:type]}Transaction".constantize
    use_case = use_case.perform(params)
    @transaction = use_case.transaction
  end
end
