# frozen_string_literal: true

module UseCases
  module Create
    module Transaction
      class Reversal < UseCase
        def initialize(params)
          super
          @params = params.except(:type)
        end

        def call
          prepare_transaction
          authorize!
          validate_transaction
          save_transaction
          invalidate_original_authorize_transaction
        end

        private

        attr_reader :params, :transaction

        def prepare_transaction
          @transaction = Transaction.new(create_params)
        end

        def authorize!
          merchant = Merchant.find(create_params[:merchant_id])
          merchant.authorize! :create, transaction
        end

        def create_transaction
          transaction.save
        end

        def invalidate_original_authorize_transaction
          @transaction.reference.status = :reversed
        end
      end
    end
  end
end
