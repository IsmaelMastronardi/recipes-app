require 'rails_helper'

RSpec.describe 'Food creation', type: :system do
  let(:user) do
    User.create(name: 'example_user', email: 'user@example.com', password: 'password', id: 1)
  end

  let(:food) do
    Food.create(name: 'apple', measurement_unit: 'grams', price: 5, quantity: 10, user_id: user.id)
  end

  before do
    token = user.confirmation_token
    user.confirmation_token = token
    user.save
    user.confirm
    sign_in user
  end

  it 'allows a user to update a food' do
    visit edit_food_path(food)
    fill_in 'Name', with: 'apple'
    fill_in 'Price', with: '10'
    fill_in 'Quantity', with: '3'
    click_button 'Update'

    expect(page).to have_content('Food was successfully updated.')
    expect(page).to have_content('apple')
    expect(page).to have_content('gram')
  end

  it 'handles no changes' do
    visit edit_food_path(food)
    click_button 'Update'

    expect(page).to have_content('Food was successfully updated')
  end
end
