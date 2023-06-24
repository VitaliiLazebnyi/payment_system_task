# frozen_string_literal: true

class Transaction < ApplicationRecord
  validate :reference_only_approved_and_refunded
  validate :proper_reference_chain
  validate :active_user, on: :create

  # Possible reference chains
  # Authorize Transaction -> Charge Transaction -> Refund Transaction
  # Authorize Transaction -> Reversal Transaction
  ALLOWED_REFERENCES = [
    %w[Authorize Charge],
    %w[Charge Refund],
    %w[Authorize Reversal]
  ].freeze

  enum :status, %i[approved reversed refunded error]

  validates :amount,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :customer_email, presence: true, length: { minimum: 3 }
  validates :customer_phone, presence: true, length: { minimum: 3 }
  validates :type, presence: true

  belongs_to :user

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

    errors.add(:reference, 'should be approved or refunded')
  end

  def proper_reference_chain
    return unless reference

    return if ALLOWED_REFERENCES.any? do |chain|
      type == chain.last && reference.type == chain.first
    end

    errors.add(:reference, "can't have '#{reference.class}' as a reference")
  end

  # def amount_by_type
  #   errors.add(:amount, :blank) if %w[Authorize Charge Refund].include?(type) && amount.empty?
  #
  #   return unless type == 'Reversal' && amount.present
  #
  #   errors.add(:amount, :present)
  # end

  def active_user
    return if user&.active

    errors.add(:user, 'should be active')
  end
end
