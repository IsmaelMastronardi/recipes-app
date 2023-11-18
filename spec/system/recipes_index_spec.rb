require 'rails_helper'

RSpec.describe 'User Integration', type: :system do
  let(:user) { User.create(name: 'example_user', email: 'user@example.com', password: 'password') }
  let!(:recipe) do
    Recipe.create(id: 103, name: 'recipe-1', preparation_time: '20 minutes',
                  cooking_time: '10 minutes', description: 'The best meal ever!', public: true, user:)
  end

  before do
    token = user.confirmation_token
    user.confirmation_token = token
    user.save
    user.confirm
    sign_in user
  end

  it 'displays the foods of a user' do
    visit recipes_path
    sleep(5)
    expect(page).to have_content('recipe-1')
    expect(page).to have_content('The best meal ever!')
  end
end
