# frozen_string_literal: true

RSpec.describe TransactionsController do
  describe 'GET #index' do
    before do
      merchant = create(:merchant)
      create(:authorize, merchant:)
      allow(controller).to receive(:current_user).and_return(merchant)
    end

    it 'assigns transactions variable' do
      get :index
      expect(assigns(:transactions)).to eq [Transaction.last]
    end

    it 'returns 200 /ok/ response code' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end
end
