# frozen_string_literal: true

RSpec.describe Charge do
  it 'is a Transaction' do
    expect(described_class.superclass).to eq(Transaction)
  end
end
