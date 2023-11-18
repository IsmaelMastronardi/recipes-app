class PublicRecipesController < ApplicationController
  def index
    @recipes = Recipe.includes(:user, :foods, food_recipes: [:food]).where(public: true)
  end
end
