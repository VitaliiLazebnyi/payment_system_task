# frozen_string_literal: true

class User < ApplicationRecord
  before_destroy :validate_no_transactions

  has_secure_password

  validates :name, presence: true, length: { minimum: 3 }
  validates :password_digest, presence: true
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

  delegate :can?, :cannot?, :authorize!, to: :ability

  private

  def validate_no_transactions
    return if transactions.empty?

    errors.add :base, :undestroyable
    throw :abort
  end

  def ability
    @ability ||= Ability.new(self)
  end
end
