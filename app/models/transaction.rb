# frozen_string_literal: true

class Transaction < ApplicationRecord
  # uuid, amount, status (approved, reversed, refunded,
  #  error), customer_email, customer_phone
  enum :status, %i[approved reversed refunded error]

  validates :amount,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :customer_email, presence: true, length: { minimum: 3 }
  validates :customer_phone, presence: true, length: { minimum: 3 }
end
