require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  let(:user) do
    User.create(name: 'example_user', email: 'user@example.com', password: 'password', id: 1)
  end
  let(:valid_attributes) do
    {
      name: 'test_recipe',
      preparation_time: '1 hour',
      cooking_time: '2 hours',
      description: 'this is a test recipe',
      public: true,
      user_id: user.id,
      id: 1
    }
  end

  let(:invalid_attributes) do
    {
      name:,
      preparation_time:,
      cooking_time:,
      description:,
      public: true,
      user_id:
    }
  end
  before(:each) do
    token = user.confirmation_token
    user.confirmation_token = token
    user.save

    # Confirm the user account
    user.confirm
    sign_in user
  end
  describe 'GET /index' do
    it 'goes to the correct path' do
      get recipes_path
      expect(response).to be_successful
      expect(response.body).to include('Show this recipe')
      expect(request.path).to eq(recipes_path)
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      recipe = Recipe.create! valid_attributes
      puts 'AAAAAAAAAAAAAA'
      get recipe_path(recipe)
      expect(response).to be_successful
      expect(response.body).to include('test_recipe')
      expect(request.path).to eq(recipe_path(recipe))
    end
  end
end
