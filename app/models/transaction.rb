# frozen_string_literal: true

class Transaction < ApplicationRecord
  validate :reference_only_approved_and_refunded

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
end
