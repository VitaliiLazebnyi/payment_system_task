# frozen_string_literal: true

RSpec.describe Transaction do
  subject { build(:transaction, merchant: build(:merchant)) }

  it { should belong_to(:merchant) }

  it {
    should have_one(:reference)
      .class_name(described_class)
      .with_foreign_key('reference_id')
      .inverse_of(:follow)
      .dependent(:nullify)
  }

  it {
    should belong_to(:follow)
      .class_name(described_class)
      .with_foreign_key('reference_id')
      .inverse_of(:reference)
      .dependent(:destroy)
      .optional
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

  describe 'amound depending on type' do
    context 'reversal transaction' do
      subject { build(:reversal, merchant: build(:merchant)) }

      it {
        should validate_numericality_of(:amount)
          .only_integer
          .is_equal_to(0)
      }
    end

    context 'refund transaction' do
      subject { build(:refund, merchant: build(:merchant)) }

      it {
        should validate_numericality_of(:amount)
          .only_integer
          .is_greater_than(0)
      }
    end

    context 'charge transaction' do
      subject { build(:charge, merchant: build(:merchant)) }

      it {
        should validate_numericality_of(:amount)
          .only_integer
          .is_greater_than(0)
      }
    end

    context 'authorize transaction' do
      subject { build(:authorize, merchant: build(:merchant)) }

      it {
        should validate_numericality_of(:amount)
          .only_integer
          .is_greater_than(0)
      }
    end
  end

  describe 'only approved or refunded can be referenced' do
    let(:merchant) { create(:merchant) }
    let(:reference) { create(:charge, merchant:) }
    let(:follow) { create(:refund, merchant:) }

    it 'references approved' do
      reference.status = :approved
      follow.reference = reference
      expect(follow.save).to be true
      expect(follow.errors).to be_empty
    end

    it 'references refunded' do
      reference.status = :refunded
      follow.reference = reference
      expect(follow.save).to be true
      expect(follow.errors).to be_empty
    end

    it "doesn't reference reversed" do
      reference.status = :reversed
      follow.reference = reference
      expect(follow.save).to be false
      expect(follow.errors).to be_present
    end

    it "doesn't reference error" do
      reference.status = :error
      follow.reference = reference
      expect(follow.save).to be false
      expect(follow.errors).to be_present
    end
  end

  describe 'validates proper reference chain' do
    let(:merchant) { create(:merchant) }

    it 'Authorize can be references by Charge' do
      reference = create(:authorize, merchant:, status: :approved)
      follow    = create(:charge, merchant:, status: :approved)
      follow.reference = reference
      expect(follow.save).to be true
      expect(follow.errors).to be_empty
    end

    it 'Charge can be references by Refund' do
      reference = create(:charge, merchant:, status: :approved)
      follow    = create(:refund, merchant:, status: :approved)
      follow.reference = reference
      expect(follow.save).to be true
      expect(follow.errors).to be_empty
    end

    it 'Authorize can be references by Reversal' do
      reference = create(:authorize, merchant:, status: :approved)
      follow    = create(:reversal, merchant:, status: :approved)
      follow.reference = reference
      expect(follow.save).to be true
      expect(follow.errors).to be_empty
    end

    it "Reversal can't be references by another Reversal" do
      reference = create(:reversal, merchant:, status: :approved)
      follow    = create(:reversal, merchant:, status: :approved)
      follow.reference = reference
      expect(follow.save).to be false
      expect(follow.errors).to be_present
    end
  end

  it "can't be created for inactive user" do
    transaction = attributes_for(:transaction, merchant: build(:merchant, active: false))
    transaction = described_class.new(transaction)
    expect(transaction.save).to be false
    expect(transaction.errors).to be_present
  end
end
