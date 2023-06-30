# frozen_string_literal: true

class CreateRefundTransaction
  include UseCase

  attr_reader :user, :params, :transaction

  def initialize(user, params)
    @user = user
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
    params.merge!(reference: @charge)
  rescue ActiveRecord::RecordNotFound
    save_error('Reference not found')
  end

  def prepare_transaction
    @transaction = Refund.new(params)
  end

  def authorize!
    user.authorize! :create, transaction
  end

  def save_transaction
    transaction.valid?
    # require 'pry'; binding.pry
    if transaction.errors.present?
      save_errors(transaction.errors.full_messages)
      transaction.status = :error
    end
    transaction.save(validate: false)
  end

  def withdraw_from_merchants_account
    return false if errors?

    merchant = transaction.merchant
    merchant.total_transaction_sum -= transaction.amount
    merchant.save
  end

  def invalidate_charge_transaction
    return false if errors

    @charge.update!(status: :refunded)
  end
end
