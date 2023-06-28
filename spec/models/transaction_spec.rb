# frozen_string_literal: true

RSpec.describe Transaction do
  subject { build(:authorize, merchant: merchant) }
  let(:merchant) { build :merchant }

  before do
    allow(subject).to receive(:handle_errors).and_return(true)
  end

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

  describe 'validate merchant activity' do
    it 'valid when merchant active' do
      subject.merchant.active = true
      expect(subject).to be_valid
    end

    it 'invalid when merchant inactive' do
      subject.merchant.active = false
      expect(subject).to_not be_valid
      expect(subject.errors[:merchant]).to include('should be active')
    end
  end

  describe 'status changes on save' do
    before do
      allow(subject).to receive(:handle_errors).and_call_original
    end

    it 'valid gives approved status' do
      subject.merchant.active = true
      expect(subject.save).to be true
      expect(subject.errors).to be_empty
      expect(subject.status).to eq 'approved'
      expect(subject.validation_errors).to be_nil
    end

    it 'invalid gives error status' do
      subject.merchant.active = false
      subject.save
      expect(subject.errors).to be_empty
      expect(subject.status).to eq 'error'
      expect(subject.validation_errors).to eq 'Merchant should be active'
    end
  end
end
