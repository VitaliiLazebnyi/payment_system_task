# frozen_string_literal: true

RSpec.describe 'Show Merchants', type: :feature do
  let!(:admin) { create(:admin) }
  let!(:merchant) { create(:merchant) }

  it 'displays merchants data to admin' do
    login(admin)
    click_link 'Show Merchants'

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

    within('.merchant.data.row') do
      expect(page).to have_content merchant.id
      expect(page).to have_content merchant.name
      expect(page).to have_content merchant.description
      expect(page).to have_content merchant.email
      if merchant.active
        expect(page).to have_content 'Active'
      else
        expect(page).to have_content 'Inactive'
      end
      expect(page).to have_content merchant.total_transaction_sum
      expect(page).to have_content 'Edit'
      expect(page).to have_content 'Delete'
    end
  end

  it 'hides merchants data from merchant' do
    login(merchant)
    expect(page).not_to have_content 'Show Merchants'
    expect(page).not_to have_content merchant.id
  end
end
