# frozen_string_literal: true

class CreateAuthorizeTransaction
  include UseCase

  attr_reader :params, :transaction

  def initialize(params)
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
    transaction.merchant.authorize! :create, transaction
  end

  def save_transaction
    transaction.valid?
    if transaction.errors.present?
      log_validation_errors(transaction.errors.full_messages.join("\n"))
      transaction.status = :error
    end
    transaction.save(validate: false)
  end
end
