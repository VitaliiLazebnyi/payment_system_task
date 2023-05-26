# frozen_string_literal: true

RSpec.describe TransactionCreator do
  let(:merchant) { create(:merchant) }

  describe 'correct params' do
    let(:transaction_params) { attributes_for(:authorize, user_id: merchant.id) }

    it 'creates a transaction' do
      success, transaction = described_class.call(transaction_params)
      expect(success).to be true
      expect(transaction.type).to eq 'Authorize'
      expect(transaction.errors).to be_empty
    end

    it "updates Merchant's total_transaction_sum" do
      total_transaction_sum = merchant.total_transaction_sum
      described_class.call(transaction_params)
      merchant.reload
      expect(merchant.total_transaction_sum).to be(total_transaction_sum + transaction_params[:amount])
    end
  end

  describe 'invalid params' do
    let(:transaction_params) { attributes_for(:authorize, user_id: merchant.id, amount: -1000) }

    it 'creates a transaction' do
      success, transaction = described_class.call(transaction_params)
      expect(success).to be false
      expect(transaction.type).to eq 'Authorize'
      expect(transaction.errors).to be_present
    end

    it "doesn't update Merchant's total_transaction_sum" do
      total_transaction_sum = merchant.total_transaction_sum
      described_class.call(transaction_params)
      merchant.reload
      expect(merchant.total_transaction_sum).to be(total_transaction_sum)
    end
  end
end
