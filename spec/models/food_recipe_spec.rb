require 'rails_helper'

RSpec.describe FoodRecipe, type: :model do
  let(:user) do
    User.create(name: 'example_user', email: 'user@example.com', password: 'password', id: 1)
  end
  let(:food) do
    Food.new(name: 'apple', measurement_unit: 'grams', price: 5, quantity: 10, user_id: user.id)
  end
  let(:recipe) do
    Recipe.create(
      name: 'test recipe',
      preparation_time: '2h',
      cooking_time: '1h',
      description: 'this is a test recipe',
      public: true,
      foods: [food],
      user_id: user.id
    )
  end
  it 'recipe shold have food' do
    expect(recipe.foods).to eq([food])
  end

  it 'food shold have recipe' do
    expect(food.recipes).to eq([recipe])
  end
end
