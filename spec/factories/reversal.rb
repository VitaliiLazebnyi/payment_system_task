# frozen_string_literal: true

FactoryBot.define do
  factory :reversal, parent: :transaction, class: 'Reversal' do
    type { 'Reversal' }
    amount { nil }
  end
end
