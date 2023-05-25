# frozen_string_literal: true

RSpec.shared_examples 'amount should be absent' do
  it 'invalid with amount' do
    transaction.amount = 1
    expect(transaction).not_to be_valid
  end

  it 'valid with without amount' do
    transaction.amount = nil
    expect(transaction).to be_valid
  end
end
