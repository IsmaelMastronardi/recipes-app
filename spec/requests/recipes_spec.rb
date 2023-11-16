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
  describe 'GET /index' do
    # it "goes to the correct path" do
    #   token = user.confirmation_token
    #   user.confirmation_token = token
    #   user.save
    #   sign_in user
    #   get recipes_path
    #   follow_redirect!
    #   if response.body.include?('Log In')
    #     # checks the login
    #     expect(response).to have_http_status(200)
    #   end
    #     # after going top login, checks the index page
    #   expect(response).to have_http_status(200)
    #   expect(response.body).to include('Show this recipe')
    # end
    it 'goes to the correct path' do
      token = user.confirmation_token
      user.confirmation_token = token
      user.save

      # Confirm the user account
      user.confirm

      # Ensure the user is confirmed
      expect(user.confirmed?).to be true

      # Sign in the user
      sign_in user

      # Try to access the recipes path
      get recipes_path

      # Expect to be redirected to the recipes path after login
      expect(response.body).to include('Show this recipe')
    end
  end

  # describe "GET /show" do
  #   it "renders a successful response" do
  #     recipe = Recipe.create! valid_attributes
  #     get recipe_path(recipe)
  #     follow_redirect!
  #     expect(response).to be_successful
  #   end
  # end
end
