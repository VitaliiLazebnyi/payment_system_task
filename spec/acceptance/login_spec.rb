# frozen_string_literal: true

RSpec.describe 'Login', type: :feature do
  let!(:admin) { create(:admin) }

  it 'login is required to use the site' do
    visit '/merchants/'
    expect(page).not_to have_content 'Logout'
    expect(page).to have_content 'Login'
    expect(page).to have_content 'Please login first!'
  end

  it 'allows to login and logout' do
    visit '/'
    expect(page).not_to have_content 'Logout'

    login(admin)
    expect(page).to have_content 'Login successful'
    expect(page).to have_content 'Logout'

    logout
    expect(page).to have_content 'Logged Out'
    expect(page).not_to have_content 'Logout'
  end

  it 'will show error if password is invalid' do
    invalid_creadentials = Struct.new(:email, :password)
                                 .new(admin.email, 'invalid_password')
    login(invalid_creadentials)
    expect(page).to have_content 'Invalid Email or Password'
    expect(page).not_to have_content 'Logout'
  end

  it 'will show error if email is invalid' do
    invalid_creadentials = Struct.new(:email, :password)
                                 .new('invalid@email.com', admin.password)
    login(invalid_creadentials)
    expect(page).to have_content 'Invalid Email or Password'
    expect(page).not_to have_content 'Logout'
  end
end
