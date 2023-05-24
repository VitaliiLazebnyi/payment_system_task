# frozen_string_literal: true

RSpec.describe User do
  subject { build(:user) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_least(3) }

  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_length_of(:description).is_at_least(3) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_length_of(:email).is_at_least(3) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to have_db_index(:email).unique }

  it { is_expected.to allow_values(true, false).for(:active) }

  it {
    is_expected.to validate_numericality_of(:total_transaction_sum)
      .only_integer
      .is_greater_than_or_equal_to(0)
  }
end
