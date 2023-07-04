# frozen_string_literal: true

RSpec.describe CreateChargeTransaction do
  let(:merchant) { create(:merchant, total_transaction_sum: 0) }
  let(:authorize) { create(:authorize, merchant:, amount: 10_000) }
  let(:charge) do
    attributes_for(
      :charge,
      merchant:,
      reference_id: authorize.id,
      customer_email: authorize.customer_email,
      customer_phone: authorize.customer_phone,
      amount: 1000
    )
  end

  describe '#perform' do
    context 'valid parameters' do
      it 'generates no errors' do
        use_case = described_class.perform(merchant, charge)
        expect(use_case.errors).to be_empty
        expect(use_case.transaction).to be_a Charge
      end

      it 'creates correct transaction' do
        use_case = described_class.perform(merchant, charge)
        expect(use_case.transaction).to be_a Charge
        expect(use_case.transaction.id).to be_present
      end

      it 'increases merchants total_transaction_sum' do
        expect(merchant.total_transaction_sum).to be_zero
        described_class.perform(merchant, charge)
        expect(merchant.total_transaction_sum).to eq 1000
      end
    end

    context 'invalid parameters' do
      it 'invalid reference id' do
        charge[:reference_id] = 'invalid_id'
        use_case = described_class.perform(merchant, charge)
        expect(use_case.errors).to include 'Reference not found'
        expect(use_case.transaction).to be_a Charge
      end
    end
  end
end
