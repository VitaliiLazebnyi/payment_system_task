# frozen_string_literal: true

module Api
  class TransactionsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :ensure_json_request
    before_action :validate_user_id

    def create
      authorize! :create, Transaction
      success, transaction = TransactionCreator.call(create_params)
      if success
        render json: transaction
      else
        render json: transaction.errors, status: :bad_request
      end
    end

    private

    def validate_user_id
      return true if current_user&.id == params.require(:transaction)[:user_id]

      render json: { error: 'User can create transactions only for himself' }, status: :unauthorized
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
  end
end
