# frozen_string_literal: true

RSpec.describe 'Error Pages', type: :feature do
  let!(:admin) { create(:admin) }

  it 'shows 404 page for nonexisting merchant' do
    login(admin)
    visit '/merchants/not_found/edit'
    expect(page).to have_content "The page you were looking for doesn't exist."
  end

  it "shows 500 page if can't save record" do
    allow(Merchant).to receive(:find).and_raise(ActiveRecord::RecordInvalid)
    login(admin)
    visit '/merchants/not_found/edit'
    expect(page).to have_content "We're sorry, but something went wrong."
  end
end
