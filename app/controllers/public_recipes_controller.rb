class PublicRecipesController < ApplicationController
  def index
    @food_recipes = FoodRecipe.all
    @recipes = Recipe.where(public: true)
  end
end
