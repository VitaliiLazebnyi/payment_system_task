# frozen_string_literal: true

RSpec.describe CreateRefundTransaction do
  let(:merchant) { create(:merchant, total_transaction_sum: 1000) }
  let(:authorize) { create(:authorize, merchant:, amount: 10_000) }
  let(:charge) do
    create(
      :charge,
      merchant:,
      reference_id: authorize.id,
      customer_email: authorize.customer_email,
      customer_phone: authorize.customer_phone,
      amount: 1000
    )
  end

  let(:refund) do
    attributes_for(
      :refund,
      merchant:,
      reference_id: charge.id,
      customer_email: authorize.customer_email,
      customer_phone: authorize.customer_phone,
      amount: 500
    )
  end

  describe '#perform' do
    context 'valid parameters' do
      it 'generates no errors' do
        use_case = described_class.perform(merchant, refund)
        expect(use_case.errors).to be_empty
        expect(use_case.transaction).to be_a Refund
      end

      it 'creates correct transaction' do
        use_case = described_class.perform(merchant, refund)
        expect(use_case.transaction).to be_a Refund
        expect(use_case.transaction.id).to be_present
      end

      it 'decreases merchants total_transaction_sum' do
        expect(merchant.total_transaction_sum).to eq 1000
        described_class.perform(merchant, refund)
        expect(merchant.total_transaction_sum).to eq 500
      end

      it 'invalidates charge transaction' do
        expect(charge.reload.status).to eq 'approved'
        described_class.perform(merchant, refund)
        expect(charge.reload.status).to eq 'refunded'
      end
    end

    context 'invalid parameters' do
      it 'invalid amount' do
        refund[:reference_id] = 'invalid_id'
        use_case = described_class.perform(merchant, refund)
        expect(use_case.errors).to include 'Reference not found'
        expect(use_case.transaction).to be_a Refund
      end
    end
  end
end
