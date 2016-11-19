class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.references  :user, null: false
      t.integer     :calorie_consumption
      t.timestamps null: false
    end
    add_index :meals, :user_id
  end
end
