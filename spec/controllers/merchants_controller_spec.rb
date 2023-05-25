# frozen_string_literal: true

RSpec.describe MerchantsController do
  before do
    create(:merchant)
  end

  describe 'GET #index' do
    it 'assigns transactions variable' do
      get :index
      expect(assigns(:merchants)).to eq [Merchant.last]
    end

    it 'returns 200 /ok/ response code' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #edit' do
    it 'assigns merchant variable' do
      get :edit, params: { id: Merchant.last.id }
      expect(assigns(:merchant)).to eq Merchant.last
    end

    it 'returns 200 /ok/ response code' do
      get :edit, params: { id: Merchant.last.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys merchant' do
      expect { delete :destroy, params: { id: Merchant.last.id } }
        .to change(Merchant, :count).by(-1)
    end

    it 'redirects to merchant index page' do
      delete :destroy, params: { id: Merchant.last.id }
      expect(response).to redirect_to(merchants_path)
    end
  end
end
