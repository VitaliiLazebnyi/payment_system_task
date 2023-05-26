# frozen_string_literal: true

RSpec.describe Api::TransactionsController do
  describe 'POST #create' do
    let(:merchant) { create(:merchant) }
    let(:merchant_2) { create(:merchant) }
    let(:transaction_params) { attributes_for(:authorize, user_id: merchant.id) }

    before do
      request.env['HTTP_AUTHORIZATION'] =
        ActionController::HttpAuthentication::Basic
          .encode_credentials(merchant.id, merchant.email)
    end

    describe 'valid parameters' do
      it 'creates a transaction' do
        expect { post :create, params: { transaction: transaction_params }, format: :json }
          .to change(Transaction, :count).by(1)
      end

      it 'returns 200 /ok/ response code' do
        post :create, params: { transaction: transaction_params }, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'invalid parameters' do
      let(:transaction_params) { attributes_for(:authorize,
                                                user_id: merchant.id,
                                                customer_email: nil) }

      it "doesn't create a transaction" do
        expect { post :create, params: { transaction: transaction_params }, format: :json }
          .not_to change(Transaction, :count)
      end

      it 'returns 400 /bad_request/ response code' do
        post :create, params: { transaction: transaction_params }, format: :json
        expect(response).to have_http_status(:bad_request)
      end
    end

    describe 'invalid request format' do
      it 'proper response body' do
        post :create, params: { transaction: {} }, format: :xml
        expect(response.body).to eq '{"error":"Invalid request format"}'
      end

      it 'returns 400 /bad_request/ response code' do
        post :create, params: { transaction: {} }, format: :xml
        expect(response).to have_http_status(:bad_request)
      end
    end

    describe 'merchant tries to create a transaction for another merchant' do
      let(:transaction_params) { attributes_for(:authorize, user_id: merchant_2.id) }

      it "doesn't create a transaction" do
        expect { post :create, params: { transaction: transaction_params }, format: :json }
          .to change(Transaction, :count).by(0)
      end

      it 'returns 401 /unauthorized/ response code' do
        post :create, params: { transaction: transaction_params }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "doesn't pass basic auth" do
      before do
        request.env['HTTP_AUTHORIZATION'] = nil
      end

      it "doesn't create a transaction" do
        expect { post :create, params: { transaction: transaction_params }, format: :json }
          .to change(Transaction, :count).by(0)
      end

      it 'returns 401 /unauthorized/ response code' do
        post :create, params: { transaction: transaction_params }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
