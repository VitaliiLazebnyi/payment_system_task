module UseCases
  module Create
    module Transaction
      class Authorize < UseCase
        def initialize(params)
          @params = params.except(:type)
        end

        def call
          prepare_transaction
          authorize!
          save_transaction
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

        def validate_transaction
          # check if absent reference
          raise if @transaction.reference
          # check if merchant is active
          raise unless @transaction.merchant.active

          # set status 'Error' if validation didn't pass?
        end

        def create_transaction
          transaction.save
        end
      end
    end
  end
end
