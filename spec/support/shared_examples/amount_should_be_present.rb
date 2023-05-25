# frozen_string_literal: true

RSpec.shared_examples 'amount should be present' do
  it 'valid with amount' do
    transaction.amount = 1
    expect(transaction).to be_valid
  end

  it 'invalid with without amount' do
    transaction.amount = nil
    expect(transaction).not_to be_valid
  end
end
