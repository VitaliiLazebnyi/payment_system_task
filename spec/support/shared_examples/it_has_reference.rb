# frozen_string_literal: true

RSpec.shared_examples 'it has reference' do
  describe 'reference type' do
    it 'can reference Authorize transaction' do
      subject.reference = authorize2
      expect(subject).to be_valid
      expect(subject.errors).to be_empty
    end

    it "can't reference nonAuthorize transaction" do
      subject.reference = reversal
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include('Reference can be only Authorize transaction')
    end
  end

  describe 'reference merchant' do
    it 'is the same in reference and Reversal' do
      subject.merchant = merchant
      expect(subject).to be_valid
      expect(subject.errors).to be_empty
    end

    it 'is different in reference and Reversal' do
      subject.merchant = merchant2
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages)
        .to include('Reference reference Merchant should be the same as Merchant')
    end
  end

  describe 'customer_email' do
    it 'is the same in reference and Reversal' do
      subject.customer_email = authorize.customer_email
      expect(subject).to be_valid
      expect(subject.errors).to be_empty
    end

    it 'is different in reference and Reversal' do
      subject.customer_email = 'different@email.com'
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages)
        .to include('Reference reference customer_email should be the same as customer_email')
    end
  end

  describe 'customer_phone' do
    it 'is the same in reference and Reversal' do
      subject.customer_phone = authorize.customer_phone
      expect(subject).to be_valid
      expect(subject.errors).to be_empty
    end

    it 'is different in reference and Reversal' do
      subject.customer_phone = '23811'
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages)
        .to include('Reference reference customer_phone should be the same as customer_phone')
    end
  end

  describe 'reference status' do
    it 'approved' do
      subject.reference.status = 'approved'
      expect(subject).to be_valid
      expect(subject.errors).to be_empty
    end

    it 'error' do
      subject.reference.status = 'error'
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages)
        .to include('Reference reference status should be approved')
    end
  end
end
