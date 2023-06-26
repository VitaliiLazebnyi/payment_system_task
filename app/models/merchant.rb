# frozen_string_literal: true

class Merchant < User
  before_destroy :validate_no_transactions

  validates :total_transaction_sum,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  has_many :transactions, dependent: :destroy

  private

  def validate_no_transactions
    return if transactions.empty?

    errors.add :base, :undestroyable
    throw :abort
  end
end
