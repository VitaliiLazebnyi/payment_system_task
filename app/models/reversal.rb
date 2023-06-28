# frozen_string_literal: true

class Reversal < Transaction
  validates :amount, absence: true

  include Referenceable
end
