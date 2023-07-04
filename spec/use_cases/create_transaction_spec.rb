# frozen_string_literal: true

RSpec.describe CreateTransaction do
  let(:merchant) { build(:merchant) }
  let(:authorize) { attributes_for(:authorize, merchant:) }

  describe '#perform' do
    context 'valid parameters' do
      it 'generates no errors' do
        use_case = described_class.perform(merchant, authorize)
        expect(use_case.errors).to be_empty
        expect(use_case.transaction).to be_a Authorize
      end

      it 'creates correct transaction' do
        use_case = described_class.perform(merchant, authorize)
        expect(use_case.transaction).to be_a Authorize
        expect(use_case.transaction.id).to be_present
      end
    end

    context 'invalid parameters' do
      it 'invalid type' do
        authorize[:type] = nil
        use_case = described_class.perform(merchant, authorize)
        expect(use_case.errors.first).to eq 'Type invalid'
        expect(use_case.transaction).to be_nil
      end

      it 'invalid merchant' do
        authorize[:merchant_id] = 'invalid'
        use_case = described_class.perform(merchant, authorize)
        expect(use_case.errors.first)
          .to eq 'Merchant_id should be the same as current_user.id'
        expect(use_case.transaction).to be_nil
      end
    end
  end
end
