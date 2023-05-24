# frozen_string_literal: true

RSpec.describe Refund do
  it 'is a Transaction' do
    expect(described_class.superclass).to eq(Transaction)
  end
end
