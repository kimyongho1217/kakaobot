class CreateMealFoods < ActiveRecord::Migration
  def change
    create_table :meal_foods do |t|
      t.references  :meal
      t.references  :food
      t.references  :food_unit
      t.integer     :count
      t.integer     :calorie_consumption
      t.timestamps null: false
    end
    add_index :meal_foods, :meal_id
  end
end
