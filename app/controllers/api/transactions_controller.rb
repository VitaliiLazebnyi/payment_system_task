# frozen_string_literal: true

module Api
  class TransactionsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :ensure_json_request
    before_action :validate_merchant_id

    rescue_from CanCan::AccessDenied, with: :access_denied

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

    def validate_merchant_id
      return true if current_user.id == params.require(:transaction)[:merchant_id]

      render json: { error: 'User can create transactions only for himself' }, status: :unauthorized
    end

    def create_params
      params.require(:transaction)
            .permit(:amount, :status, :customer_email, :customer_phone,
                    :type, :merchant_id, :reference_id)
    end

    def ensure_json_request
      return if request.format.json?

      render json: { error: 'Invalid request format' }, status: :bad_request
    end

    def current_user
      return @current_user if @current_user
      authenticate_or_request_with_http_basic do |email, password|
        merchant = Merchant.find_by(email: email)
        @current_user = merchant if merchant&.authenticate(password)
        !!@current_user
      end
    end

    def access_denied
      respond_to do |format|
        format.json { head :forbidden }
      end
    end
  end
end
