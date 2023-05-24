# frozen_string_literal: true

RSpec.describe Transaction do
  subject { build(:transaction) }

  it {
    is_expected.to validate_numericality_of(:amount)
      .only_integer
      .is_greater_than_or_equal_to(1)
  }

  it {
    is_expected.to define_enum_for(:status)
      .with_values(%i[approved reversed refunded error])
  }

  it { is_expected.to validate_presence_of(:customer_email) }
  it { is_expected.to validate_length_of(:customer_email).is_at_least(3) }

  it { is_expected.to validate_presence_of(:customer_phone) }
  it { is_expected.to validate_length_of(:customer_phone).is_at_least(3) }
end
