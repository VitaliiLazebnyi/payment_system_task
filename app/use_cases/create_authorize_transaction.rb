# frozen_string_literal: true

class CreateAuthorizeTransaction
  include UseCase

  attr_reader :user, :params, :transaction

  def initialize(user, params)
    @user = user
    @params = params.except(:type)
  end

  def perform
    prepare_transaction
    authorize!
    save_transaction
  end

  private

  def prepare_transaction
    @transaction = Authorize.new(params)
  end

  def authorize!
    user.authorize! :create, transaction
  end

  def save_transaction
    transaction.valid?
    save_errors(transaction.errors.full_messages)
    transaction.save(validate: false)
  end
end
