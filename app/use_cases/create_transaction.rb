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

    save_error('Merchant_id should be the same as current_user.id')
  end

  def validate_transaction_type
    return true if Transaction::CLASSES.include?(params[:type])

    save_error('Type invalid')
  end

  def create_transaction
    # transaction will not be created if failed basic validations
    return false if errors?

    use_case = "Create#{params[:type]}Transaction".constantize
    use_case = use_case.perform(user, params)
    @transaction = use_case.transaction
    save_errors(use_case.errors)
  end
end
