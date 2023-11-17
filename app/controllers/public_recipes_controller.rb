class PublicRecipesController < ApplicationController
  def index
    @food_recipes = FoodRecipe.all
    @recipes = Recipe.all
  end
end
