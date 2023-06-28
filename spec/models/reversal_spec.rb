# frozen_string_literal: true

RSpec.describe Reversal do
  subject(:transaction) { build(:refund, merchant:) }

  let(:merchant) { build(:merchant) }

  it_behaves_like 'amount should be present'

  it 'is a Transaction' do
    expect(described_class.superclass).to eq(Transaction)
  end
end
