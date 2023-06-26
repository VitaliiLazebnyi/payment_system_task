# frozen_string_literal: true

module SessionHelpers
  def login(user)
    visit '/'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log In'
  end

  def logout
    click_link 'Logout'
  end
end
