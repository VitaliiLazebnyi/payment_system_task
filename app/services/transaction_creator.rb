# frozen_string_literal: true

class TransactionCreator < ApplicationService
  attr_reader :create_params, :merchant_id

  def initialize(create_params)
    @create_params = create_params
    @merchant_id   = create_params[:user_id]
  end

  def call
    success = false
    transaction = Transaction.new(create_params)
    merchant = Merchant.find(create_params[:user_id])
    merchant.authorize! :create, transaction
    ActiveRecord::Base.transaction do
      success = transaction.save
      merchant.total_transaction_sum += transaction.amount
      merchant.save
    end
    [success, transaction]
  end
end
