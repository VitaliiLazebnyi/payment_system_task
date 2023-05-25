# frozen_string_literal: true

FactoryBot.define do
  factory :authorize, parent: :transaction do
    type { 'Authorize' }
  end
end
