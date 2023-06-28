# frozen_string_literal: true

RSpec.describe Merchant do
  it { should have_many(:transactions) }

  it {
    should validate_numericality_of(:total_transaction_sum)
      .only_integer
      .is_greater_than_or_equal_to(0)
  }

  it 'is a User' do
    expect(described_class.superclass).to eq(User)
  end
end
