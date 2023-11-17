require 'set'

class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[show edit update destroy toggle_public]

  # GET /recipes or /recipes.json
  def index
    @recipes = Recipe.all
  end

  # GET /recipes/1 or /recipes/1.json
  def show; end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit; end

  # POST /recipes or /recipes.json
  def create
    @recipe = Recipe.new(recipe_params)

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to recipe_url(@recipe), notice: 'Recipe was successfully created.' }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  def new_food
    @recipe = Recipe.find(params[:id])
    @food = Food.new
  end

  def create_food
    @recipe = Recipe.find(params[:id])
    @food = Food.build(food_params.except(:id))
    @recipe.foods << @food
    if @food.save
      redirect_to recipe_path(@recipe), notice: 'Food was successfully added to the recipe.'
    else
      render :new_food
    end
  end

  # PATCH/PUT /recipes/1 or /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(public_switch_params)
        format.html { redirect_to recipe_url(@recipe), notice: 'Recipe was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1 or /recipes/1.json
  def destroy
    @recipe.destroy!

    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'Recipe was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Togle between public and private
  def toggle_public
    @recipe.toggle!(:public)
    if @recipe.public
      puts 'public'
    else
      puts 'private'
    end
  end

  def general_shopping_list
    @recipes = current_user.recipes

    recipes_food_arr = []
    @recipes.each { |r| recipes_food_arr.concat(r.foods) }
    @foods_arr = current_user.foods


    @grouped_recipe_foods = {}
    recipes_food_arr.each do |f|
      if @grouped_recipe_foods.key?(f.name)
        @grouped_recipe_foods[f.name][1] += f.quantity
      else
        @grouped_recipe_foods[f.name] = []
        @grouped_recipe_foods[f.name] << f.measurement_unit
        @grouped_recipe_foods[f.name] << f.quantity
        @grouped_recipe_foods[f.name] << f.price
      end
    end


    @grouped_user_foods = {}
    @foods_arr.each do |f|
      if @grouped_user_foods.key?(f.name)
        @grouped_user_foods[f.name][1] += f.quantity
      else
        @grouped_user_foods[f.name] = []
        @grouped_user_foods[f.name] << f.measurement_unit
        @grouped_user_foods[f.name] << f.quantity
        @grouped_user_foods[f.name] << f.price
      end
    end

    @grouped_recipe_foods.each do |key, recipe_food|
      next unless @grouped_user_foods.key?(key)

      recipe_quantity = recipe_food[1]
      user_quantity = @grouped_user_foods[key][1]

      if user_quantity >= recipe_quantity
        @grouped_user_foods[key][1] -= recipe_quantity
        @grouped_recipe_foods[key][1] = 0
      else
        @grouped_recipe_foods[key][1] -= user_quantity
        @grouped_user_foods[key][1] = 0
      end
    end

    @total_price = 0
    @grouped_recipe_foods.each do |key|
      @total_price += @grouped_recipe_foods[key][2] * @grouped_recipe_foods[key][1]
    end

    puts @grouped_recipe_foods
  end

  # DELETE
  private

  def user_list; end

  # Use callbacks to share common setup or constraints between actions.
  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :description, :public, :user_id)
  end

  def public_switch_params
    puts params
    params.require(:recipe).permit(:public)
  end

  def food_params
    params.require(:food).permit(:name, :description, :measurement_unit, :price, :quantity)
  end
end
