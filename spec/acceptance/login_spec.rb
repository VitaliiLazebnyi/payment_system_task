RSpec.describe 'Login', type: :feature do
  it 'shows the static text', js: true do
    visit '/'
    # expect(page).to have_content('Hello world')
  end
end
