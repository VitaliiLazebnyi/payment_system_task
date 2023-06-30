# frozen_string_literal: true

class Charge < Transaction
  validates :amount, numericality: { only_integer: true, greater_than: 0 }
  validate :reference_amount

  include Referenceable

  private

  def reference_amount
    return if amount && reference&.amount && reference.amount >= amount

    errors.add(:reference, 'reference amount should be bigger or the same as amount')
  end
end
