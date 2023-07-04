# frozen_string_literal: true

RSpec.describe CreateAuthorizeTransaction do
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
      it 'invalid reference' do
        authorize[:amount] = -1
        use_case = described_class.perform(merchant, authorize)
        expect(use_case.errors.first).to eq 'Amount must be greater than 0'
        expect(use_case.transaction).to be_a Authorize
      end
    end
  end
end
