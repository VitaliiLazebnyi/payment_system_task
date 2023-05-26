# frozen_string_literal: true

module Api
  class TransactionsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :ensure_json_request
    before_action :basic_auth

    def create
      success, transaction = create_transaction
      if success
        render json: transaction
      else
        render json: transaction.errors, status: :bad_request
      end
    end

    private

    def user_id_param
      params.require(:transaction)[:user_id]
    end

    def create_transaction
      success = false
      transaction = Transaction.new(create_params)
      merchant = Merchant.find(user_id_param)
      ActiveRecord::Base.transaction do
        success = transaction.save
        merchant.total_transaction_sum += transaction.amount
        merchant.save
      end
      [success, transaction]
    end

    def create_params
      params.require(:transaction)
            .permit(:amount, :status, :customer_email, :customer_phone,
                    :type, :user_id, :reference_id)
    end

    def ensure_json_request
      return if request.format.json?

      render json: { error: 'Invalid request format' }, status: :bad_request
    end

    def validate_user_id(id)
      return true if id == user_id_param

      render json: { error: 'User can create transactions only for himself' }, status: :unauthorized
    end

    def basic_auth
      authenticate_or_request_with_http_basic do |id, email|
        validate_user_id(id) &&
          User.where(id:, email:, type: 'Merchant').present?
      end
    end
  end
end
