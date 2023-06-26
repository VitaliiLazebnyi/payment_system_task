# frozen_string_literal: true

RSpec.describe 'Delete Merachants', type: :feature do
  let!(:admin) { create(:admin) }
  let!(:merchant) { create(:merchant) }

  it 'allows to delete merchants for admin' do
    login(admin)
    click_link 'Show Merchants'
    click_button 'Delete'
    within('.merchant_titles') do
      expect(page).to have_content 'id'
      expect(page).to have_content 'name'
      expect(page).to have_content 'description'
      expect(page).to have_content 'email'
      expect(page).to have_content 'status'
      expect(page).to have_content 'total_transaction_sum'
      expect(page).to have_content 'edit'
      expect(page).to have_content 'delete'
    end

    expect(page).not_to have_content merchant.id
  end
end
