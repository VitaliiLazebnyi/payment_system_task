# frozen_string_literal: true

module UseCases
  module Create
    module Transaction
      class Authorize < UseCase
        def initialize(params)
          super
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
          @transaction = Authorize.new(create_params)
        end

        def authorize!
          transaction.merchant.authorize! :create, transaction
        end

        def create_transaction
          transaction.save
        end
      end
    end
  end
end
