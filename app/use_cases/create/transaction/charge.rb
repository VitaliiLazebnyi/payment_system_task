module UseCases
  module Create
    module Transaction
      class Charge < UseCase
        def initialize(params)
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
          merchant = Merchant.find(create_params[:merchant_id])
          merchant.authorize! :create, transaction
        end

        def validate_transaction
          # check if present reference
          raise unless @transaction.reference
          # check if reference is a Authorize transaction with approved state
          raise if @transaction.reference.type != 'Authorize'
          # check if merchant is active
          raise unless @transaction.merchant.active
          # check if merchant from this and original transaction is the same
          raise if @transaction.reference.merchant != @transaction.merchant
          # check if customer is the same
          raise if @transaction.reference.customer_email == @transaction.customer_email &&
            @transaction.reference.customer_phone == @transaction.customer_phone
          # check if customer has enough money on the balance
          raise if @transaction.reference.amount < @transaction.amount

          # set status 'Error' if validation didn't pass?
        end

        def create_transaction
          transaction.save
        end

        def top_up_merchants_account
          # if the status is not :error
        end
      end
    end
  end
end
