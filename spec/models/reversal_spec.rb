# frozen_string_literal: true

RSpec.describe Reversal do
  subject(:reversal) do
    build(:reversal,
          customer_email: authorize.customer_email,
          customer_phone: authorize.customer_phone,
          reference: authorize,
          merchant:)
  end

  let(:merchant) { build(:merchant) }
  let(:merchant2) { build(:merchant) }

  let(:authorize) { build(:authorize, merchant:) }

  let(:authorize2) do
    build(:authorize,
          customer_email: authorize.customer_email,
          merchant:)
  end

  before do
    allow(reversal).to receive(:handle_errors).and_return(true)
  end

  it_behaves_like 'it has reference'

  it 'is a Transaction' do
    expect(described_class.superclass).to eq(Transaction)
  end
end
