# frozen_string_literal: true

FactoryBot.define do
  factory :authorize, parent: :transaction, class: 'Authorize' do
    type { 'Authorize' }
  end
end
