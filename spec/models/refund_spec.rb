# frozen_string_literal: true

RSpec.describe Refund do
  subject(:transaction) { build(:refund, merchant:) }

  let(:merchant) { build(:merchant) }

  it 'is a Transaction' do
    expect(described_class.superclass).to eq(Transaction)
  end
end
