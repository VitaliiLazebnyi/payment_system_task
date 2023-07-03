# frozen_string_literal: true

RSpec.describe Authorize do
  subject(:authorize) { build(:authorize, merchant:) }

  let(:merchant) { build(:merchant) }

  it {
    should validate_numericality_of(:amount)
      .only_integer
      .is_greater_than(0)
  }

  it 'is a Transaction' do
    expect(described_class.superclass).to eq(Transaction)
  end
end
