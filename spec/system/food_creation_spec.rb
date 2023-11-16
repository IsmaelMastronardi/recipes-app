require 'rails_helper'

RSpec.describe 'Food creation', type: :system do
  let(:user) do
    User.create(name: 'example_user', email: 'user@example.com', password: 'password', id: 1)
  end

  before do
    token = user.confirmation_token
    user.confirmation_token = token
    user.save
    user.confirm
    sign_in user
  end

  it 'allows a user to create a new food' do
    visit new_food_path
    fill_in 'Name', with: 'banana'
    fill_in 'Measurement unit', with: 'gram'
    fill_in 'Price', with: '10'
    fill_in 'Quantity', with: '2'
    click_button 'Create'

    expect(page).to have_content('Food was successfully created.')
    expect(page).to have_content('banana')
    expect(page).to have_content('gram')
  end

  it 'handles invalid data gracefully' do
    visit new_food_path
    click_button 'Create'

    expect(page).to have_content("New Food")
  end
end
