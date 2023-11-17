require 'rails_helper'

RSpec.describe 'General Shopping List View', type: :system do
  let(:user) do
    User.create(name: 'example_user', email: 'user@example.com', password: 'password', id: 1)
  end
  let(:food) do
    Food.create(
      name: 'apple',
      measurement_unit: 'grams',
      price: 10,
      quantity: 0,
      user_id: user.id
    )
  end
  let(:recipe) do
    Recipe.create(
      name: 'test recipe',
      preparation_time: '2 hours',
      cooking_time: '1 hour',
      description: 'this is a test description',
      public: true,
      user_id: user.id
    )
  end
  let(:food_recipe) do
    FoodRecipe.create(
      food:,
      recipe:,
      quantity: 2
    )
  end

  before do
    token = user.confirmation_token
    user.confirmation_token = token
    user.save
    user.confirm
    sign_in user
  end
  it 'displays the details of a recipe' do
    puts food_recipe.quantity
    visit general_shopping_list_user_path(user)

    save_and_open_page
    expect(page).to have_content('Amount of food items to buy: 1')
    expect(page).to have_content('Total value of food needed: 20')
    expect(page).to have_content('apple')
    expect(page).to have_content('grams')
  end
  # it 'displays the details of a recipes food' do
  #   visit general_shopping_list_user_path(user)

  #   expect(page).to have_content('apple')
  #   expect(page).to have_content('10')
  #   expect(page).to have_content('2')
  # end
end
