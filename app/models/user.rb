# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true, length: { minimum: 3 }
  validates :password_digest, presence: true
  validates :description, presence: true, length: { minimum: 3 }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { minimum: 3 }
  validates :active, inclusion: { in: [true, false] }
  validates :type, presence: true

  delegate :can?, :cannot?, :authorize!, to: :ability

  private

  def ability
    @ability ||= Ability.new(self)
  end
end
