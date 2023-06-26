# frozen_string_literal: true

RSpec.describe 'Edit Merchants', type: :feature do
  let!(:admin) { create(:admin) }
  let!(:merchant) { create(:merchant) }

  it 'displays merchants data to admin' do
    login(admin)
    click_link 'Show Merchants'
    click_link 'Edit'

    fill_in 'Name', with: 'new_user_name'
    fill_in 'Description', with: 'new_description'
    fill_in 'Email', with: 'new@email.com'
    click_button 'Save'

    click_link 'Show Merchants'
    within('.merchant.data.row') do
      expect(page).to have_content merchant.id
      expect(page).to have_content 'new_user_name'
      expect(page).to have_content 'new_description'
      expect(page).to have_content 'new@email.com'
    end
  end
end
