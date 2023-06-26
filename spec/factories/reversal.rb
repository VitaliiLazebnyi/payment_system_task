# frozen_string_literal: true

FactoryBot.define do
  factory :reversal, parent: :transaction do
    type { 'Reversal' }
    amount { 0 }
  end
end
