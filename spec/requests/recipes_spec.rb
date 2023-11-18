require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Foods index', type: :request do
  let(:user) do
    User.create(name: 'example_user', email: 'user@example.com', password: 'password')
  end
  let!(:recipe) do
    Recipe.create(
      name: 'recipe-1',
      preparation_time: '20 minutes',
      cooking_time: '10 minutes',
      description: 'The best meal ever!',
      public: true,
      user:
    )
  end

  before do
    token = user.confirmation_token
    user.confirmation_token = token
    user.save
    user.confirm
    sign_in user
  end

  describe 'GET /recipes' do
    it 'Renders the index page for recipes successfully' do
      get '/recipes'
      expect(response.status).to eq(200)
      expect(response).to render_template('index')
    end
    it 'Display correct recipe details' do
      get '/recipes'
      expect(response.status).to eq(200)
      expect(response).to render_template('index')
      expect(response.body).to include('recipe-1')
      expect(response.body).to include('The best meal ever!')
    end
  end
end
