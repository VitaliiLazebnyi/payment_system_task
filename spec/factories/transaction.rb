# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    amount { rand(1..10_000) }
    status { Transaction.statuses.keys.sample }
    customer_email { "email_#{Time.now.to_f}@gmail.com" }
    customer_phone { "+380#{Time.now.to_i}" }
  end
end
