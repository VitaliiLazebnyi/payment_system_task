# frozen_string_literal: true

class Charge < Transaction
  validates :references, presence: true
  validate :reference_type
  validate :reference_merchant
  validate :reference_customer_email
  validate :reference_customer_phone
  validate :reference_status
  validate :reference_amount

  private

  def reference_type
    return if reference&.type == 'Authorize'
    errors.add(:reference, 'can reference only Authorize transaction')
  end

  def reference_merchant
    return if reference&.merchant == merchant
    errors.add(:reference, 'reference Merchant should be the same as Merchant')
  end

  def reference_customer_email
    return if reference&.customer_email == customer_email
    errors.add(:reference, 'reference customer_email should be the same as customer_email')
  end

  def reference_customer_phone
    return if reference&.customer_phone == customer_phone
    errors.add(:reference, 'reference customer_phone should be the same as customer_phone')
  end

  def reference_status
    return if reference&.status == 'approved'
    errors.add(:reference, 'reference status should be approved')
  end

  def reference_amount
    return if reference&.amount >= amount
    errors.add(:reference, 'reference amount should be bigger or the same as amount')
  end
end
