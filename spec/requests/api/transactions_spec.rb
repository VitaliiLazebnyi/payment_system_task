# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/transactions' do
  path '/api/transactions' do
    post('create transaction') do
      description <<~DESCRIPTION
        Authorize transaction - has amount and used to hold customer's amount.
        Charge transaction - has amount and used to conﬁrm the amount is taken from the customer's account and transferred to the merchant. The merchant's total transactions amount has to be the sum of the approved Charge transactions.
        Refund transaction - has amount and used to reverse a speciﬁc amount (whole amount) of the Charge Transaction and return it to the customer Transitions the Charge transaction to status refunded. The approved Refund transactions will decrease the merchant'stotal transaction amount.
        Reversal transaction - has no amount, used to invalidate the Authorize Transaction. Transitions the Authorize transaction to status reversed
      DESCRIPTION
      tags 'transactions'
      produces 'application/json'
      consumes 'application/json'
      security [basic_auth: []]

      parameter name: :params,
                in: :body,
                schema: { '$ref' => '#/components/transaction_in' }

      response '201', 'authorize transaction created', swagger_strict_schema_validation: true do
        let(:transaction) { attributes_for(:authorize, merchant_id: merchant.id) }

        run_test!

        schema(
          type: :object,
          properties: {
            transaction: { '$ref' => '#/components/transaction_out' },
            errors: {
              type: :array,
              items: {
                type: :string
              }
            }
          }
        )
      end

      response 400, 'Bad request' do
        run_test!
      end

      response 401, 'Unauthorized' do
        run_test!
      end
    end
  end
end
