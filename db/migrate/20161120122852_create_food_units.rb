class CreateFoodUnits < ActiveRecord::Migration
  def change
    create_table :food_units do |t|
      t.string :name, null: false
      t.integer :weight_per_unit, null: false
      t.references :food, null: false
      t.timestamps null: false
    end
  end
end
