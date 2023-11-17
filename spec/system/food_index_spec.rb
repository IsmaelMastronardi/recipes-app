require 'rails_helper'

RSpec.describe 'User Integration', type: :system do
  let(:user) { User.create(name: 'example_user', email: 'user@example.com', password: 'password') }
  let!(:food) { Food.create(name: 'apple', measurement_unit: 'grams', price: '10', quantity: '2', user:) }

  before do
    token = user.confirmation_token
    user.confirmation_token = token
    user.save
    user.confirm
    sign_in user
  end

  it 'displays the foods of a user' do
    visit foods_path
    sleep(5)
    expect(page).to have_content('apple')
    expect(page).to have_content('grams')
    expect(page).to have_content('$10')
    expect(page).to have_content('Add food')
  end

  it 'Click Add food button' do
    visit foods_path
    click_link('Add food')
    sleep(5)
    expect(current_path).to eq(new_food_path)
  end
end
