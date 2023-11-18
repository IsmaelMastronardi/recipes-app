class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
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

      next unless result.total_quantity > user_food.quantity

      quantity_to_buy = result.total_quantity - user_food.quantity
      total_price = quantity_to_buy * result.price

      shopping_list[result.name] = {
        quantity: quantity_to_buy,
        measurement_unit: result.measurement_unit,
        total_price:
      }

      total_value += total_price
    end
    { shopping_list:, total_value: }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name)
  end
end
