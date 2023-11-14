class Food < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  has_many :food_recipes
  has_many :recipes, through: :food_recipes
end
