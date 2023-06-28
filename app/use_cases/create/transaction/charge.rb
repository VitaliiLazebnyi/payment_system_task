# frozen_string_literal: true

module UseCases
  module Create
    module Transaction
      class Charge < UseCase
        def initialize(params)
          super
          @params = params.except(:type)
        end

        def call
          prepare_transaction
          authorize!
          validate_transaction
          save_transaction
          top_up_merchants_account
        end

        private

        attr_reader :params, :transaction

        def prepare_transaction
          @transaction = Transaction.new(create_params)
        end

        def authorize!
          transaction.merchant.authorize! :create, transaction
        end

        def create_transaction
          transaction.save
        end

        def top_up_merchants_account
          merchant = transaction.merchant
          merchant.total_transaction_sum += transaction.amount
          merchant.save
        end
      end
    end
  end
end
