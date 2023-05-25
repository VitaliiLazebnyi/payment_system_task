# frozen_string_literal: true

RSpec.describe User do
  subject { build(:user) }

  it { should have_many(:transactions) }

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

  it { is_expected.to validate_presence_of(:type) }

  context '#destroy' do
    it "can be destroyed if doesn't contain transactions" do
      user = create :user
      expect { user.destroy }.to change { User.count }.by(-1)
    end

    it "can't be destroyed if contains transactions" do
      user = create :user
      user.transactions.create attributes_for(:refund)
      expect { user.destroy }.to_not change { User.count }
    end
  end
end
