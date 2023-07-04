# frozen_string_literal: true

RSpec.describe CreateReversalTransaction do
  let(:merchant) { create(:merchant) }
  let(:authorize) { create(:authorize, merchant:) }
  let(:reversal) do
    attributes_for(
      :reversal,
      merchant:,
      reference_id: authorize.id,
      customer_email: authorize.customer_email,
      customer_phone: authorize.customer_phone
    )
  end

  describe '#perform' do
    context 'valid parameters' do
      it 'generates no errors' do
        use_case = described_class.perform(merchant, reversal)
        expect(use_case.errors).to be_empty
        expect(use_case.transaction).to be_a Reversal
      end

      it 'creates correct transaction' do
        use_case = described_class.perform(merchant, reversal)
        expect(use_case.transaction).to be_a Reversal
        expect(use_case.transaction.id).to be_present
      end

      it 'invalidates authorize transaction' do
        expect(authorize.reload.status).to eq 'approved'
        described_class.perform(merchant, reversal)
        expect(authorize.reload.status).to eq 'reversed'
      end
    end

    context 'invalid parameters' do
      it 'invalid reference id' do
        reversal[:reference_id] = 'invalid_id'
        use_case = described_class.perform(merchant, reversal)
        expect(use_case.errors).to include 'Reference not found'
        expect(use_case.transaction).to be_a Reversal
      end
    end
  end
end
