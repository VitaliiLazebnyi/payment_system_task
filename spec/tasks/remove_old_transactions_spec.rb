# frozen_string_literal: true

describe 'rake remove:old:transactions' do
  before do
    time = 1.hour.ago - 1.second
    create(:authorize, created_at: time, updated_at: time, merchant: create(:merchant))
  end

  it 'removes old transactions' do
    expect { Rake::Task['remove:old:transactions'].invoke }
      .to change(Transaction, :count).by(-1)
  end
end
