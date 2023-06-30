# frozen_string_literal: true

class Transaction < ApplicationRecord
  CLASSES = %w[Authorize Charge Refund Reversal].freeze

  enum status: { approved: 0, reversed: 1, refunded: 2, error: 3 }

  validates :customer_email, presence: true, length: { minimum: 3 }
  validates :customer_phone, presence: true, length: { minimum: 3 }
  validates :type, presence: true, inclusion: { in: CLASSES }
  validate :active_merchant, on: :create

  belongs_to :merchant

  has_one :follow,
          class_name: 'Transaction',
          foreign_key: 'reference_id',
          inverse_of: :reference,
          dependent: :destroy

  private

  def log_validation_errors(errors)
    validation_errors ||= ''
    divider = validation_errors.empty? ? '' : "\n"
    validation_errors << (divider + errors)
  end

  def active_merchant
    return if merchant&.active

    errors.add(:merchant, 'should be active')
  end
end
