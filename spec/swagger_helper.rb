# frozen_string_literal: true

RSpec.configure do |config|
  config.swagger_strict_schema_validation = true

  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      components: {
        securitySchemes: {
          basic_auth: {
            type: :http,
            scheme: :basic,
            name: 'Authorization'
          }
        },
        transaction_in: {
          type: :object,
          properties: {
            amount: { type: :integer, minimum: 1, example: 1000 },
            customer_email: { type: :string, minLength: 3, example: 'customer@email.com' },
            customer_phone: { type: :string, minLength: 3, example: '+38093123456789' },
            type: { type: :string, enum: %w[Authorize Reversal Charge Refund], example: 'Authorize',
                    description: 'Transaction will not be created at all if type is invalid or absent.' },
            merchant_id: { type: :string, format: :uuid, example: '5578ec3a-c9d3-49e1-b91c-5d321ced56aa' },
            reference_id: { type: :string, format: :uuid, example: nil,
                            description: 'Transaction with the same customer and merchant ' \
                                         'which can be changed by current transaction.' }
          },
          required: %w[customer_email type customer_phone merchant_id]
        },
        transaction_out: {
          type: :object,
          properties: {
            id: { type: :string, format: :uuid, example: 'c285d56b-b972-4a56-9bef-17516902d5dd' },
            amount: { type: :integer, minimum: 1, example: 1000 },
            status: { type: :string, enum: %w[approved reversed refunded error], example: 'approved' },
            customer_email: { type: :string, minLength: 3, example: 'customer@email.com' },
            customer_phone: { type: :string, minLength: 3, example: '+38093123456789' },
            created_at: { type: :string, format: 'date-time', example: '2023-06-30T21:31:32.999Z' },
            updated_at: { type: :string, format: 'date-time', example: '2023-06-30T21:31:32.999Z' },
            merchant_id: { type: %i[string nil], format: :uuid, example: '5578ec3a-c9d3-49e1-b91c-5d321ced56aa' },
            reference_id: { type: %i[string nil], format: :uuid, example: nil }
          },
          required: %w[id amount status customer_email customer_phone created_at updated_at merchant_id reference_id]
        }
      },
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            }
          }
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
