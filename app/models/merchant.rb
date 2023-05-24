# frozen_string_literal: true

class Merchant < ApplicationRecord
  validates :name, presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 3 }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { minimum: 3 }
  validates :active, inclusion: { in: [true, false] }
  validates :total_transaction_sum,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 },
            presence: true
end
