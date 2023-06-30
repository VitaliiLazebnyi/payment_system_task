# frozen_string_literal: true

class CreateChargeTransaction
  include UseCase

  attr_reader :user, :params, :transaction

  def initialize(user, params)
    @user = user
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
  rescue ActiveRecord::RecordNotFound
    save_error('Reference not found')
  end

  def prepare_transaction
    @transaction = Charge.new(params)
  end

  def authorize!
    user.authorize! :create, transaction
  end

  def save_transaction
    transaction.valid?
    if transaction.errors.present?
      save_errors(transaction.errors.full_messages)
      transaction.status = :error
    end
    transaction.save(validate: false)
  end

  def top_up_merchants_account
    return false if errors?

    merchant = transaction.merchant
    merchant.total_transaction_sum += transaction.amount
    merchant.save
  end
end
