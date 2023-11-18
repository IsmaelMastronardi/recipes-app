require 'rails_helper'

RSpec.describe Food, type: :model do
  let(:user) do
    User.create(name: 'example_user', email: 'user@example.com', password: 'password', id: 1)
  end
  subject { Food.new(name: 'apple', measurement_unit: 'grams', price: 5, quantity: 10, user_id: user.id) }

  before { subject.save }

  it 'is valid with all present parameters' do
    expect(subject).to be_valid
  end

  it 'is not valid with null name' do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid with null measurement_unit' do
    subject.measurement_unit = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid with null price' do
    subject.price = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid with null naquantityme' do
    subject.quantity = nil
    expect(subject).to_not be_valid
  end

  it 'should belong to user' do
    expect(user.foods).to eq([subject])
  end
end
