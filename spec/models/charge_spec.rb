# frozen_string_literal: true

RSpec.describe Charge do
  subject(:charge) { build(:charge,
                             customer_email: authorize.customer_email,
                             customer_phone: authorize.customer_phone,
                             reference: authorize,
                             merchant:) }

  let(:merchant) { build :merchant }
  let(:merchant2) { build :merchant }

  let(:authorize) { build :authorize, amount: 10000, merchant: }

  let(:authorize2) { build :authorize,
                           amount: 10000,
                           customer_email: authorize.customer_email,
                           merchant: }

  let(:reversal) { build(:reversal,
                           customer_email: authorize.customer_email,
                           customer_phone: authorize.customer_phone,
                           reference: authorize,
                           merchant:) }

  before do
    allow(subject).to receive(:handle_errors).and_return(true)
  end

  it_behaves_like "it has reference"

  describe 'reference amount' do
    it 'smaller' do
      subject.reference.amount = 100
      subject.amount = 1
      expect(subject).to be_valid
      expect(subject.errors).to be_empty
    end

    it 'same' do
      subject.reference.amount = 100
      subject.amount = 100
      expect(subject).to be_valid
      expect(subject.errors).to be_empty
    end

    it 'bigger' do
      subject.reference.amount = 1
      subject.amount = 100
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages)
        .to include('Reference reference amount should be bigger or the same as amount')
    end
  end

  it 'is a Transaction' do
    expect(described_class.superclass).to eq(Transaction)
  end
end
