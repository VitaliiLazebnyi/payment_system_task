# frozen_string_literal: true

RSpec.describe Api::TransactionsController do
  describe 'POST #create' do
    let(:merchant) { create(:merchant) }
    let(:merchant2) { create(:merchant) }
    let(:transaction_params) { attributes_for(:authorize, merchant_id: merchant.id) }

    before do
      allow(controller).to receive(:current_user).and_return(merchant)
    end

    describe 'valid parameters' do
      it 'creates a transaction' do
        expect { post :create, params: { transaction: transaction_params }, format: :json }
          .to change(Transaction, :count).by(1)
      end

      it "updates Merchant's total_transaction_sum" do
        total_transaction_sum = merchant.total_transaction_sum
        post :create, params: { transaction: transaction_params }, format: :json
        merchant.reload
        expect(merchant.total_transaction_sum).to be(total_transaction_sum + transaction_params[:amount])
      end

      it 'returns 200 /ok/ response code' do
        post :create, params: { transaction: transaction_params }, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'invalid parameters' do
      let(:transaction_params) do
        attributes_for(:authorize,
                       merchant_id: merchant.id,
                       customer_email: nil)
      end

      it "doesn't create a transaction" do
        expect { post :create, params: { transaction: transaction_params }, format: :json }
          .not_to change(Transaction, :count)
      end

      it 'returns 400 /bad_request/ response code' do
        post :create, params: { transaction: transaction_params }, format: :json
        expect(response).to have_http_status(:bad_request)
      end
    end

    describe "merchant_id's in parameters and session are different" do
      before do
        allow(controller).to receive(:current_user).and_return(merchant)
      end

      let(:transaction_params) do
        attributes_for(:authorize, merchant_id: merchant2.id)
      end

      it "doesn't create a transaction" do
        expect { post :create, params: { transaction: transaction_params }, format: :json }
          .not_to change(Transaction, :count)
      end

      it 'returns 400 /bad_request/ response code' do
        post :create, params: { transaction: transaction_params }, format: :json
        expect(response).to have_http_status(:unauthorized)
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
      let(:transaction_params) { attributes_for(:authorize, merchant_id: merchant2.id) }

      it "doesn't create a transaction" do
        expect { post :create, params: { transaction: transaction_params }, format: :json }
          .not_to change(Transaction, :count)
      end

      it 'returns 401 /unauthorized/ response code' do
        post :create, params: { transaction: transaction_params }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "doesn't pass basic auth" do
      before do
        allow(controller).to receive(:current_user).and_return(nil)
      end

      it "doesn't create a transaction" do
        expect { post :create, params: { transaction: transaction_params }, format: :json }
          .not_to change(Transaction, :count)
      end

      it 'redirect to login page' do
        post :create, params: { transaction: transaction_params }, format: :json
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
