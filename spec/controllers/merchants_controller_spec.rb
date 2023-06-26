# frozen_string_literal: true

RSpec.describe MerchantsController do
  before do
    create(:merchant)
    admin = create(:admin)
    allow(controller).to receive(:current_user).and_return(admin)
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

  describe 'PUT #update' do
    let(:params) { { name: 'new_name' } }

    it 'updates merchant' do
      put :update, params: { id: Merchant.last.id, merchant: params }
      expect(Merchant.last.name).to eq params[:name]
    end

    it 'returns 200 /ok/ response code' do
      put :update, params: { id: Merchant.last.id, merchant: params }
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
