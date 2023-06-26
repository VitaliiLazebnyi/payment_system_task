# frozen_string_literal: true

RSpec.describe 'Show Transactions', type: :feature do
  let!(:admin) { create(:admin) }
  let!(:merchant) { create(:merchant) }
  let!(:transaction) { create(:authorize, user: merchant) }

  it 'displays merchants data to admin' do
    login(admin)
    click_link 'Show Transactions'

    within('.transaction_titles.row.header') do
      expect(page).to have_content 'id'
      expect(page).to have_content 'type'
      expect(page).to have_content 'amount'
      expect(page).to have_content 'status'
      expect(page).to have_content 'customer_email'
      expect(page).to have_content 'customer_phone'
      expect(page).to have_content 'user_id'
      expect(page).to have_content 'reference_id'
    end

    within('.transaction.row') do
      expect(page).to have_content transaction.id
      expect(page).to have_content transaction.type
      expect(page).to have_content transaction.amount
      expect(page).to have_content transaction.status
      expect(page).to have_content transaction.customer_email
      expect(page).to have_content transaction.customer_phone
      expect(page).to have_content transaction.user_id
      expect(page).to have_content transaction.reference_id
    end
  end
end
