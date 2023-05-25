# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { "Name #{Time.now.to_f}" }
    description { "Description #{Time.now.to_f}." }
    email { "email_#{Time.now.to_f}@gmail.com" }
    active { true }
    total_transaction_sum { rand(128) }
  end
end
