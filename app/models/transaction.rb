# frozen_string_literal: true

class Transaction < ApplicationRecord
  after_validation :handle_errors

  enum :status, %i[approved reversed refunded error]

  validates :customer_email, presence: true, length: { minimum: 3 }
  validates :customer_phone, presence: true, length: { minimum: 3 }
  validates :type, presence: true
  validate :active_merchant, on: :create

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

  def active_merchant
    return if merchant&.active

    errors.add(:merchant, 'should be active')
  end

  def handle_errors
    if errors.present?
      self.validation_errors = errors.full_messages.join("\n")
      self.status = 'error'
    else
      self.status = 'approved'
    end

    errors.clear
  end
end
