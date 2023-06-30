# frozen_string_literal: true

class Transaction < ApplicationRecord
  CLASSES = %w[Authorize Charge Refund Reversal].freeze

  enum status: %i[approved reversed refunded error]

  validates :customer_email, presence: true, length: { minimum: 3 }
  validates :customer_phone, presence: true, length: { minimum: 3 }
  validates :type, presence: true, inclusion: { in: CLASSES }
  validate :active_merchant, on: :create

  belongs_to :merchant

  has_one :follow, class_name: 'Transaction', foreign_key: 'reference_id'

  private

  def log_validation_errors(errors)
    validation_errors = '' unless validation_errors
    divider = validation_errors.empty? ? '' : "\n"
    validation_errors << divider + errors
  end

  def active_merchant
    return if merchant&.active

    errors.add(:merchant, 'should be active')
  end
end
