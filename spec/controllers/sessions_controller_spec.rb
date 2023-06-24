# frozen_string_literal: true

RSpec.describe SessionsController do
  let(:admin) { create(:admin) }
  let(:merchant) { create(:merchant) }

  describe 'GET #new' do
    context 'visitor' do
      it 'returns 200 /ok/ response code' do
        get :new
        expect(response).to have_http_status(:ok)
      end
    end

    context 'admin' do
      before do
        allow(controller).to receive(:current_user).and_return(admin)
      end

      it 'redirect to 403' do
        get :new
        expect(response).to redirect_to('/403')
      end
    end

    context 'merchant' do
      before do
        allow(controller).to receive(:current_user).and_return(admin)
      end

      it 'redirect to 403' do
        get :new
        expect(response).to redirect_to('/403')
      end
    end
  end

  describe 'POST #create' do
    context 'visitor with correct email/password' do
      it 'returns 201 /created/ response code' do
        post :create, params: { email: admin.email, password: admin.password }
        expect(response).to redirect_to(root_path)
      end

      it 'saves user_id to session' do
        post :create, params: { email: admin.email, password: admin.password }
        expect(session[:user_id]).to eq admin.id
      end
    end

    context 'visitor with incorrect email/password' do
      let(:email) { 'invalid@email.com' }
      let(:password) { 'invalid@password' }

      it 'returns 201 /created/ response code' do
        post :create, params: { email:, password: }
        expect(response).to redirect_to("#{login_path}?email=#{email}")
      end

      it 'saves user_id to session' do
        post :create, params: { email:, password: }
        expect(session[:user_id]).to be_nil
      end
    end

    context 'admin' do
      before do
        allow(controller).to receive(:current_user).and_return(admin)
      end

      it 'returns 403 /forbidden/ response code' do
        post :create, params: { email: admin.email, password: admin.password }
        expect(response).to redirect_to('/403')
      end
    end

    context 'merchant' do
      before do
        allow(controller).to receive(:current_user).and_return(admin)
      end

      it 'returns 403 /forbidden/ response code' do
        post :create, params: { email: admin.email, password: admin.password }
        expect(response).to redirect_to('/403')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'visitor' do
      before do
        allow(controller).to receive(:current_user).and_return(nil)
        session[:user_id] = nil
      end

      it 'redirect to 403' do
        delete :destroy
        expect(response).to redirect_to(login_path)
      end

      it 'removes user_id from session' do
        delete :destroy
        expect(session[:user_id]).to be_nil
      end
    end

    context 'admin' do
      before do
        allow(controller).to receive(:current_user).and_return(admin)
        session[:user_id] = admin.id
      end

      it 'redirect to 403' do
        delete :destroy
        expect(response).to redirect_to(login_path)
      end

      it 'removes user_id from session' do
        expect(session[:user_id]).not_to be_nil
        delete :destroy
        expect(session[:user_id]).to be_nil
      end
    end

    context 'merchant' do
      before do
        allow(controller).to receive(:current_user).and_return(merchant)
        session[:user_id] = merchant.id
      end

      it 'redirect to 403' do
        delete :destroy
        expect(response).to redirect_to(login_path)
      end

      it 'removes user_id from session' do
        expect(session[:user_id]).not_to be_nil
        delete :destroy
        expect(session[:user_id]).to be_nil
      end
    end
  end
end
