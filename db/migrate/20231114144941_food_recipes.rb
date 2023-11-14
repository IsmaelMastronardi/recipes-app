class CreateRecipeFoods < ActiveRecord::Migration[7.1]
  def change
    create_table :food_recipes do |t|
      t.integer :quantity
      t.references :recipe_id, foreign_key: { to_table: :recipes }
      t.references :food_id, foreign_key: { to_table: :foods }

      t.timestamps
    end
  end
end
