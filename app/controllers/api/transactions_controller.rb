# frozen_string_literal: true

module Api
  class TransactionsController < ApplicationController
    # protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token
    before_action :ensure_json_request

    def create
      t = Transaction.new(create_params)
      if t.save
        render json: t
      else
        render json: t.errors, status: :bad_request
      end
    end

    private

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
