# frozen_string_literal: true

FactoryBot.define do
  factory :charge, parent: :transaction do
    type { 'Charge' }
  end
end
