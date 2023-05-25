# frozen_string_literal: true

FactoryBot.define do
  factory :merchant, parent: :user do
    type { 'Merchant' }
  end
end
