# frozen_string_literal: true

RSpec.describe User do
  subject { build(:user) }

  it { should have_many(:transactions) }

  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_least(3) }

  it { should validate_presence_of(:description) }
  it { should validate_length_of(:description).is_at_least(3) }

  it { should validate_presence_of(:email) }
  it { should validate_length_of(:email).is_at_least(3) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should have_db_index(:email).unique }

  it { should allow_values(true, false).for(:active) }

  it {
    should validate_numericality_of(:total_transaction_sum)
      .only_integer
      .is_greater_than_or_equal_to(0)
  }

  it { should validate_presence_of(:type) }

  describe '#destroy' do
    it "can be destroyed if doesn't contain transactions" do
      user = create(:user)
      expect { user.destroy }.to change(described_class, :count).by(-1)
    end

    it "can't be destroyed if contains transactions" do
      user = create(:user)
      user.transactions.create attributes_for(:refund)
      expect { user.destroy }.not_to(change(described_class, :count))
    end
  end
end
