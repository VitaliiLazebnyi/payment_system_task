# frozen_string_literal: true

RSpec.describe Transaction do
  subject(:transaction) { build(:authorize, merchant:) }

  let(:merchant) { build(:merchant) }

  it { should belong_to(:merchant) }

  # it {
  #   should have_one(:reference)
  #     .class_name(described_class)
  #     .with_foreign_key('reference_id')
  #     .inverse_of(:follow)
  #     .dependent(:nullify)
  # }
  #
  # it {
  #   should belong_to(:follow)
  #     .class_name(described_class)
  #     .with_foreign_key('reference_id')
  #     .inverse_of(:reference)
  #     .dependent(:destroy)
  #     .optional
  # }

  it {
    should define_enum_for(:status)
      .with_values(%i[approved reversed refunded error])
  }

  it { should validate_presence_of(:customer_email) }
  it { should validate_length_of(:customer_email).is_at_least(3) }

  it { should validate_presence_of(:customer_phone) }
  it { should validate_length_of(:customer_phone).is_at_least(3) }

  it { should validate_presence_of(:type) }

  describe 'validate merchant activity' do
    it 'valid when merchant active' do
      transaction.merchant.active = true
      expect(transaction).to be_valid
    end

    it 'invalid when merchant inactive' do
      transaction.merchant.active = false
      expect(transaction).not_to be_valid
      expect(transaction.errors[:merchant]).to include('should be active')
    end
  end

  describe 'status changes on save' do
    it 'valid gives approved status' do
      transaction.merchant.active = true
      expect(transaction.save).to be true
      expect(transaction.errors).to be_empty
      expect(transaction.status).to eq 'approved'
    end

    it 'invalid gives error status' do
      transaction.merchant.active = false
      transaction.save
      expect(transaction.status).to eq 'error'
      expect(transaction.errors).to be_present
    end
  end
end
