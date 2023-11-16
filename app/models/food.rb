class Food < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  has_many :food_recipes
  has_many :recipes, through: :food_recipes

  validates :name, presence: true
  validates :measurement_unit ,presence: true
  validates :price, presence: true
  validates :quantity, presence: true
end
