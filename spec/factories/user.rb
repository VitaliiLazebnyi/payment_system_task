# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { "Name #{Time.now.to_f}" }
    password { SecureRandom.base36(64) }
    description { "Description #{Time.now.to_f}." }
    email { "email_#{Time.now.to_f}@gmail.com" }
    active { true }
  end
end
