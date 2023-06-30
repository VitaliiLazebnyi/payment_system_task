# frozen_string_literal: true

class CreateChargeTransaction
  include UseCase

  attr_reader :params, :transaction

  def initialize(params)
    @params = params.except(:type)
  end

  def perform
    load_authorize_transaction
    prepare_transaction
    authorize!
    save_transaction
    top_up_merchants_account
  end

  private

  def load_authorize_transaction
    @authorize = Authorize.find(params[:reference_id])
    params.merge!(reference: @authorize)
  end

  def prepare_transaction
    @transaction = Charge.new(params)
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

  def top_up_merchants_account
    return if transaction.validation_errors

    merchant = transaction.merchant
    merchant.total_transaction_sum += transaction.amount
    merchant.save
  end
end