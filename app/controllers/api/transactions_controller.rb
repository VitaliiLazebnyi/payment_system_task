# frozen_string_literal: true

module Api
  class TransactionsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :ensure_json_request

    rescue_from CanCan::AccessDenied, with: :access_denied

    def create
      authorize! :create, Transaction
      use_case = CreateTransaction.perform(current_user, create_params)
      render json: { transaction: use_case.transaction,
                     errors: use_case.errors },
             status: :created
    end

    private

    def create_params
      params.require(:transaction)
            .permit(:amount, :customer_email, :customer_phone,
                    :type, :merchant_id, :reference_id)
    end

    def ensure_json_request
      return if request.format.json?

      render json: { error: 'Invalid request format' }, status: :bad_request
    end

    def current_user
      return @current_user if @current_user

      authenticate_or_request_with_http_basic do |email, password|
        merchant = Merchant.find_by(email:)
        @current_user = merchant if merchant&.authenticate(password)
        !@current_user.nil?
      end
    end

    def access_denied
      respond_to do |format|
        format.json { head :forbidden }
      end
    end
  end
end
