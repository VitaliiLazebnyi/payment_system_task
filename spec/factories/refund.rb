# frozen_string_literal: true

FactoryBot.define do
  factory :refund, parent: :transaction do
    type { 'Refund' }
  end
end
