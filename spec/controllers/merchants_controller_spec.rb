# frozen_string_literal: true

RSpec.describe MerchantsController do
  describe 'GET #index' do
    before do
      create(:merchant)
    end

    it 'assigns transactions variable' do
      get :index
      expect(assigns(:merchants)).to eq [Merchant.last]
    end

    it 'returns 200 /ok/ response code' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end
end
