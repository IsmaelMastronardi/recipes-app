class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[show edit update destroy toggle_public]

  # GET /recipes or /recipes.json
  def index
    return unless user_signed_in?

    @recipes = Recipe.where(user_id: current_user.id)
  end

  # GET /recipes/1 or /recipes/1.json
  def show
    return unless user_signed_in?

  end

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
    @food = Food.build(food_params.except(:quantity))
    @food.user_id = current_user.id
    @food.quantity = 0
    @food_recipe = FoodRecipe.build(food:@food, recipe:@recipe, quantity: food_params[:quantity])
    if @food.save && @food_recipe.save
      puts @food_recipe.quantity
      redirect_to recipe_path(@recipe), notice: 'Food was successfully added to the recipe.'
    else
      puts @food.errors.full_messages
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
    @list = generate_shopping_list(current_user)
  end
  def generate_shopping_list(user)
    shopping_list = {}
    total_value = 0
  
    FoodRecipe.joins(recipe: :user)
              .joins(:food)
              .where(users: { id: user.id })
              .group('foods.name, foods.measurement_unit, foods.price')
              .select('foods.name, foods.measurement_unit, SUM(food_recipes.quantity) AS total_quantity, foods.price')
              .each do |result|
  
      user_food = user.foods.find_by(name: result.name)
  
      if result.total_quantity > user_food.quantity
        quantity_to_buy = result.total_quantity - user_food.quantity
        total_price = quantity_to_buy * result.price
  
        shopping_list[result.name] = {
          quantity: quantity_to_buy,
          measurement_unit: result.measurement_unit,
          total_price: total_price
        }
  
        total_value += total_price
      end
    end
    { shopping_list: shopping_list, total_value: total_value }
  end

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
