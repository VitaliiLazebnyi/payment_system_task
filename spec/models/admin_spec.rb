# frozen_string_literal: true

RSpec.describe Admin do
  it 'is a User' do
    expect(described_class.superclass).to eq(User)
  end
end
