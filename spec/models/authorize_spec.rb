# frozen_string_literal: true

RSpec.describe Authorize do
  subject(:transaction) { build(:authorize, merchant: merchant) }

  let(:merchant) { build(:merchant) }

  it_behaves_like 'amount should be present'

  it 'is a Transaction' do
    expect(described_class.superclass).to eq(Transaction)
  end
end
