require 'rails_helper'

RSpec.describe 'Recipe show', type: :system do
  let(:user) do
    User.create(name: 'example_user', email: 'user@example.com', password: 'password', id: 1)
  end
  let(:food) do
    Food.create(
      name: 'apple',
      measurement_unit: 'grams',
      price: '10',
      quantity: '2',
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
  it 'displays the details of a recipe' do
    visit recipe_path(recipe)
    expect(page).to have_content('test recipe')
    expect(page).to have_content('2 hours')
    expect(page).to have_content('1 hour')
    expect(page).to have_content('this is a test description')
  end
  it 'displays the details of a recipes food' do
    visit recipe_path(recipe)

    expect(page).to have_content('apple')
    expect(page).to have_content('10')
    expect(page).to have_content('2')
  end
end
