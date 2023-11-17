require 'rails_helper'

RSpec.describe 'Food creation', type: :system do
  let(:user) do
    User.create(name: 'example_user', email: 'user@example.com', password: 'password', id: 1)
  end

  let(:food) do
    Food.create(name: 'apple', measurement_unit: 'grams', price: 5, quantity: 10, user_id: user.id)
  end

  let(:recipe) do
    Recipe.create(
      name: 'test recipe',
      preparation_time: '2 hours',
      cooking_time: '1 hour',
      description: 'this is a test description',
      public: true,
      foods: [food],
      user_id: user.id
    )
  end

  before do
    token = user.confirmation_token
    user.confirmation_token = token
    user.save
    user.confirm
    sign_in user
  end

  it 'allows a user to update a food' do
    visit recipe_path(recipe)
    # Before delete
    expect(page).to have_content('apple')
    
    click_button 'Remove'

    # After delete
    expect(page).to_not have_content('apple')
  end
end
