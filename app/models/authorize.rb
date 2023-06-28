# frozen_string_literal: true

class Authorize < Transaction
  validates :reference, absence: true
  validates :amount, numericality: { only_integer: true, greater_than: 0 }
end
