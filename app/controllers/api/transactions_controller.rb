# frozen_string_literal: true

module Api
  class TransactionsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :ensure_json_request
    before_action :basic_auth

    def create
      t = Transaction.new(create_params)
      if t.save
        render json: t
      else
        render json: t.errors, status: :bad_request
      end
    end

    private

    def user_id_param
      params.require(:transaction)[:user_id]
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
      render json: { error: 'User can create transactions only for himself' }, status:  :unauthorized
    end

    def basic_auth
      authenticate_or_request_with_http_basic do |id, email|
        validate_user_id(id) &&
        User.where(id: id, email: email, type: 'Merchant').present?
      end
    end
  end
end
