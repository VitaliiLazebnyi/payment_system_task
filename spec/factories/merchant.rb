# frozen_string_literal: true

FactoryBot.define do
  factory :merchant, parent: :user, class: "Merchant" do
    type { 'Merchant' }
    total_transaction_sum { rand(128) }
  end
end
