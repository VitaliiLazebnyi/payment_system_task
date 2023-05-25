# frozen_string_literal: true

RSpec.describe Transaction do
  subject { build(:transaction) }

  it { should belong_to(:user) }

  it {
    should validate_numericality_of(:amount)
      .only_integer
      .is_greater_than_or_equal_to(1)
  }

  it {
    should define_enum_for(:status)
      .with_values(%i[approved reversed refunded error])
  }

  it { should validate_presence_of(:customer_email) }
  it { should validate_length_of(:customer_email).is_at_least(3) }

  it { should validate_presence_of(:customer_phone) }
  it { should validate_length_of(:customer_phone).is_at_least(3) }

  it { should validate_presence_of(:type) }
end
