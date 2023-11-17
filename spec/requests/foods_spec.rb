require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Foods index', type: :request do
  let(:user) do
    User.create(name: 'example_user', email: 'user@example.com', password: 'password')
  end
  let!(:food) do
    Food.create(
      name: 'apple',
      measurement_unit: 'grams',
      price: '10',
      quantity: '2',
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

  describe 'GET /foods' do
    it 'Renders the index page successfully' do
      get '/foods'
      expect(response.status).to eq(200)
      expect(response).to render_template('index')
      expect(response.body).to include('Measurement Unit')
      expect(response.body).to include('Unit Price')
      expect(response.body).to include('Action')
    end

    it 'Displays the correct table header on the browser' do
      get '/foods'
      expect(response.body).to include('Measurement Unit')
      expect(response.body).to include('Unit Price')
      expect(response.body).to include('Action')
    end

    it 'Display correct table content' do
      get '/foods'
      expect(response.status).to eq(200)
      expect(response).to render_template('index')
      expect(response.body).to include('apple')
      expect(response.body).to include('grams')
      expect(response.body).to include('10')
    end
  end
end
