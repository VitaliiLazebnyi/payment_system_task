# frozen_string_literal: true

class Authorize < Transaction
  validates :amount, numericality: { only_integer: true, greater_than: 0 }

  has_one :follow,
          class_name: 'Transaction',
          foreign_key: :reference_id,
          inverse_of: :reference,
          dependent: :destroy
end
