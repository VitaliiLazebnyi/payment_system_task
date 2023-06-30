# frozen_string_literal: true

class Transaction < ApplicationRecord
  CLASSES = %w[Authorize Charge Refund Reversal].freeze

  after_validation :handle_errors

  enum status: %i[approved reversed refunded error]

  validates :customer_email, presence: true, length: { minimum: 3 }
  validates :customer_phone, presence: true, length: { minimum: 3 }
  validates :type, presence: true, inclusion: { in: CLASSES }
  validate :active_merchant, on: :create

  belongs_to :merchant

  has_one :follow, class_name: 'Transaction', foreign_key: 'reference_id'

  private

  def active_merchant
    return if merchant&.active

    errors.add(:merchant, 'should be active')
  end

  def handle_errors
    if errors.present?
      self.validation_errors = "#{self.validation_errors}\n#{errors.full_messages.join("\n")}"
      self.status = 'error'
    end

    errors.clear
    # require 'pry'; binding.pry
    # true
  end
end
