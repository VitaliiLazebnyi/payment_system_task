# frozen_string_literal: true

RSpec.describe ApplicationController do
  describe '.current_user' do
    let(:merchant) { create(:merchant) }

    context 'when session[:user_id] is filled' do
      before do
        session[:user_id] = merchant.id
      end

      it 'returns @current_user if present' do
        controller.instance_variable_set(:@current_user, merchant)
        expect(User).not_to receive(:find)
        expect(controller.current_user).to eq merchant
      end

      it 'fills @current_user if absent' do
        controller.instance_variable_set(:@current_user, nil)
        expect(User).to receive(:find).with(merchant.id).and_return(merchant).once
        expect(controller.current_user).to eq merchant
      end
    end

    context 'when session[:user_id] is empty' do
      before do
        session[:user_id] = nil
      end

      it 'fills and @current_user if absent' do
        expect(User).not_to receive(:find)
        expect(controller.current_user).to be_nil
      end
    end

    context 'when session[:user_id] is outdated' do
      before do
        session[:user_id] = merchant.id
        allow(User).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
      end

      it 'removes @current_user if invalid' do
        expect(controller.current_user).to be_nil
        expect(controller.instance_variable_get(:@current_user)).to be_nil
        expect(session[:user_id]).to be_nil
      end
    end
  end
end
