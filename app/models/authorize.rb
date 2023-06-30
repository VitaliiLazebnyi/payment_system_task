# frozen_string_literal: true

class Authorize < Transaction
  validates :amount, numericality: { only_integer: true, greater_than: 0 }
end
