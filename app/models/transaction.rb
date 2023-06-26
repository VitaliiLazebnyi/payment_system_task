# frozen_string_literal: true

class Transaction < ApplicationRecord
  validate :reference_only_approved_and_refunded
  validate :proper_reference_chain
  validate :active_user, on: :create

  validates :amount, numericality: { only_integer: true, equal_to: 0 },
                     if: -> { type == 'Reversal' }
  validates :amount, numericality: { only_integer: true, greater_than: 0 },
                     if: -> { %w[Authorize Charge Refund].include?(type) }

  # Possible reference chains
  # Authorize Transaction -> Charge Transaction -> Refund Transaction
  # Authorize Transaction -> Reversal Transaction
  ALLOWED_REFERENCES = [
    %w[Authorize Charge],
    %w[Charge Refund],
    %w[Authorize Reversal]
  ].freeze

  enum :status, %i[approved reversed refunded error]

  validates :customer_email, presence: true, length: { minimum: 3 }
  validates :customer_phone, presence: true, length: { minimum: 3 }
  validates :type, presence: true

  belongs_to :merchant

  has_one :reference,
          class_name: :Transaction,
          foreign_key: :reference_id,
          dependent: :nullify,
          inverse_of: :follow,
          validate: true

  belongs_to :follow,
             class_name: :Transaction,
             foreign_key: :reference_id,
             dependent: :destroy,
             inverse_of: :reference,
             optional: true,
             validate: true

  private

  def reference_only_approved_and_refunded
    return if !reference || %w[approved refunded].include?(reference.status)
    self.status = :error
  end

  def proper_reference_chain
    return unless reference

    return if ALLOWED_REFERENCES.any? do |chain|
      type == chain.last && reference.type == chain.first
    end

    errors.add(:reference, "can't have '#{reference.class}' as a reference")
  end

  def active_user
    return if merchant&.active

    errors.add(:user, 'should be active')
  end
end
