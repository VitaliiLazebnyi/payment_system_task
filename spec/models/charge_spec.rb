# frozen_string_literal: true

RSpec.describe Charge do
  subject(:charge) do
    build(:charge,
          customer_email: authorize.customer_email,
          customer_phone: authorize.customer_phone,
          reference: authorize,
          merchant:)
  end

  let(:merchant) { build(:merchant) }
  let(:merchant2) { build(:merchant) }

  let(:authorize) { build(:authorize, amount: 10_000, merchant:) }

  let(:authorize2) do
    build(:authorize,
          amount: 10_000,
          customer_email: authorize.customer_email,
          merchant:)
  end

  let(:reversal) do
    build(:reversal,
          customer_email: authorize.customer_email,
          customer_phone: authorize.customer_phone,
          reference: authorize,
          merchant:)
  end

  before do
    allow(charge).to receive(:handle_errors).and_return(true)
  end

  it_behaves_like 'it has reference'

  describe 'reference amount' do
    it 'smaller' do
      charge.reference.amount = 100
      charge.amount = 1
      should be_valid
      expect(charge.errors).to be_empty
    end

    it 'same' do
      charge.reference.amount = 100
      charge.amount = 100
      should be_valid
      expect(charge.errors).to be_empty
    end

    it 'bigger' do
      charge.reference.amount = 1
      charge.amount = 100
      should_not be_valid
      expect(charge.errors.full_messages)
        .to include('Reference reference amount should be bigger or the same as amount')
    end
  end

  it 'is a Transaction' do
    expect(described_class.superclass).to eq(Transaction)
  end
end
