# frozen_string_literal: true

class Charge < Transaction
  include Referenceable

  validate :reference_amount

  private

  def reference_amount
    return if reference&.amount&.>= amount

    errors.add(:reference, 'reference amount should be bigger or the same as amount')
  end
end
