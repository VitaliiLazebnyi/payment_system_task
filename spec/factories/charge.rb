# frozen_string_literal: true

FactoryBot.define do
  factory :charge, parent: :transaction, class: Charge do
    type { 'Charge' }
  end
end
