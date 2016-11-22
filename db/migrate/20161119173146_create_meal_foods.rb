class CreateMealFoods < ActiveRecord::Migration
  def change
    create_table :meal_foods do |t|
      t.references  :meal, null: false
      t.references  :food, null: false
      t.references  :food_unit, null: false
      t.integer     :count, null: false
      t.integer     :calorie_consumption, default: 0
      t.timestamps null: false
    end
    add_index :meal_foods, :meal_id
  end
end
