# frozen_string_literal: true

class User < ApplicationRecord
  before_destroy :validate_no_transactions

  validates :name, presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 3 }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { minimum: 3 }
  validates :active, inclusion: { in: [true, false] }
  validates :total_transaction_sum,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :type, presence: true

  has_many :transactions, dependent: :destroy

  private
  def validate_no_transactions
    return if transactions.empty?

    errors.add :base, :undestroyable
    throw :abort
  end
end
