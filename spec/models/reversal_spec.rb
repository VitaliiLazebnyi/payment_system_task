# frozen_string_literal: true

RSpec.describe Reversal do
  it 'is a Transaction' do
    expect(described_class.superclass).to eq(Transaction)
  end
end
