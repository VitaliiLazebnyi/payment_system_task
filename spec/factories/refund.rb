# frozen_string_literal: true

FactoryBot.define do
  factory :refund, parent: :transaction, class: Refund do
    type { 'Refund' }
  end
end
