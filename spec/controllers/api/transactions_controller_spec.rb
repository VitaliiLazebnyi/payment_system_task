# frozen_string_literal: true

RSpec.describe Api::TransactionsController do
  describe 'POST #create' do
    let!(:merchant) { create(:merchant) }
    let!(:merchant2) { create(:merchant) }
    let!(:authorize) { create(:authorize, amount: 100_000, merchant:) }
    let(:transaction_params) do
      attributes_for(
        :charge,
        merchant_id: merchant.id,
        reference_id: authorize.id,
        customer_email: authorize.customer_email,
        customer_phone: authorize.customer_phone
      )
    end

    before do
      request.env['HTTP_AUTHORIZATION'] =
        ActionController::HttpAuthentication::Basic
        .encode_credentials(merchant.email, merchant.password)
    end

    describe 'valid parameters' do
      it 'creates a transaction' do
        expect do
          post :create, params: { transaction: transaction_params }, format: :json
        end.to change(Transaction, :count).by(1)
      end

      it "updates Merchant's total_transaction_sum" do
        total_transaction_sum = merchant.total_transaction_sum
        post :create, params: { transaction: transaction_params }, format: :json
        merchant.reload
        expect(merchant.total_transaction_sum).to be(total_transaction_sum + transaction_params[:amount])
      end

      it 'returns 200 /ok/ response code' do
        post :create, params: { transaction: transaction_params }, format: :json
        expect(response).to have_http_status(:created)
      end
    end

    describe 'invalid parameters' do
      let(:transaction_params) do
        attributes_for(:authorize,
                       merchant_id: merchant.id,
                       customer_email: nil)
      end

      it 'create a transaction' do
        expect { post :create, params: { transaction: transaction_params }, format: :json }
          .to change(Transaction, :count).by(1)
      end

      it 'created transaction status is error' do
        post :create, params: { transaction: transaction_params }, format: :json
        expect(Transaction.order('created_at').first.status).to eq 'approved'
        expect(Transaction.order('created_at').last.status).to eq 'error'
      end

      it 'returns 400 /bad_request/ response code' do
        post :create, params: { transaction: transaction_params }, format: :json
        expect(response).to have_http_status(:bad_request)
      end
    end

    describe "merchant_id's in parameters and session are different" do
      # before do
      #   allow(controller).to receive(:current_user).and_return(merchant)
      # end

      let(:transaction_params) do
        attributes_for(:authorize, merchant_id: merchant2.id)
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

      it 'returns 400 /bad request/ response code' do
        post :create, params: { transaction: transaction_params }, format: :json
        expect(response).to have_http_status(:bad_request)
      end
    end

    describe 'no basic auth' do
      before do
        request.env['HTTP_AUTHORIZATION'] = nil
      end

      it "doesn't create a transaction" do
        expect { post :create, params: { transaction: transaction_params }, format: :json }
          .not_to change(Transaction, :count)
      end

      it 'returns :unauthorized' do
        post :create, params: { transaction: transaction_params }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'basic auth with invalid email' do
      before do
        request.env['HTTP_AUTHORIZATION'] =
          ActionController::HttpAuthentication::Basic
          .encode_credentials('invalid_email', merchant.password)
      end

      it "doesn't create a transaction" do
        expect { post :create, params: { transaction: transaction_params }, format: :json }
          .not_to change(Transaction, :count)
      end

      it 'returns :unauthorized' do
        post :create, params: { transaction: transaction_params }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'basic auth with invalid password' do
      before do
        request.env['HTTP_AUTHORIZATION'] =
          ActionController::HttpAuthentication::Basic
          .encode_credentials(merchant.email, 'invalid_password')
      end

      it "doesn't create a transaction" do
        expect { post :create, params: { transaction: transaction_params }, format: :json }
          .not_to change(Transaction, :count)
      end

      it 'returns :unauthorized' do
        post :create, params: { transaction: transaction_params }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'admin tries to create transaction' do
      let!(:admin) { create(:admin) }

      before do
        request.env['HTTP_AUTHORIZATION'] =
          ActionController::HttpAuthentication::Basic
          .encode_credentials(admin.email, admin.password)
      end

      it "doesn't create a transaction" do
        expect { post :create, params: { transaction: transaction_params }, format: :json }
          .not_to change(Transaction, :count)
      end

      it 'returns :unauthorized' do
        post :create, params: { transaction: transaction_params }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'no permissions to create transaction' do
      before do
        allow(CreateTransaction).to receive(:perform).and_raise(CanCan::AccessDenied)
      end

      it 'returns :unauthorized' do
        post :create, params: { transaction: transaction_params }, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
