# frozen_string_literal: true

class Transaction < ApplicationRecord
  CLASSES = %w[Authorize Charge Refund Reversal].freeze

  after_validation :set_status

  enum status: { approved: 0, reversed: 1, refunded: 2, error: 3 }

  validates :customer_email, presence: true, length: { minimum: 3 }
  validates :customer_phone, presence: true, length: { minimum: 3 }
  validates :type, presence: true, inclusion: { in: CLASSES }
  validate :active_merchant, on: :create

  belongs_to :merchant

  belongs_to :reference,
             class_name: 'Transaction',
             optional: true,
             validate: false

  has_one :follow,
          class_name: 'Transaction',
          foreign_key: :reference_id,
          inverse_of: :reference,
          dependent: :nullify

  private

  def set_status
    self.status = :error if errors.present?
  end

  def active_merchant
    return if merchant&.active

    errors.add(:merchant, 'should be active')
  end
end
