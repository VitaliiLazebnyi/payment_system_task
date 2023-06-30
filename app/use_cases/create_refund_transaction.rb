# frozen_string_literal: true

class CreateRefundTransaction
  include UseCase

  attr_reader :params, :transaction

  def initialize(params)
    @params = params.except(:type)
  end

  def perform
    load_charge_transaction
    prepare_transaction
    authorize!
    save_transaction
    withdraw_from_merchants_account
    invalidate_charge_transaction
  end

  private

  def load_charge_transaction
    @charge = Charge.find(params[:reference_id])
    # params.merge!(reference: @charge)
  end

  def prepare_transaction
    @transaction = Refund.new(params)
  end

  def authorize!
    merchant = Merchant.find(params[:merchant_id])
    merchant.authorize! :create, transaction
  end

  def save_transaction
    transaction.valid?
    if transaction.errors.present?
      log_validation_errors(transaction.errors.full_messages.join("\n"))
      transaction.status = :error
    end
    transaction.save(validate: false)
  end

  def withdraw_from_merchants_account
    return if transaction.validation_errors

    merchant = transaction.merchant
    merchant.total_transaction_sum -= transaction.amount
    merchant.save
  end

  def invalidate_charge_transaction
    return if transaction.validation_errors

    @charge.update!(status: :refunded)
  end
end