class PublicRecipesController < ApplicationController
  def index
    # @food_recipes = FoodRecipe.all
    # @recipes = Recipe.where(public: true)
    @food_recipes = FoodRecipe.includes(:recipe, :food).all
    @recipes = Recipe.includes(:foods, :food_recipes).where(public: true)
  end
end
