class ChangeFoodUnitInMealFood < ActiveRecord::Migration
  def self.up
    change_table :meal_foods do |t|
      t.change :food_unit_id, :integer, null: true
      t.change :count, :integer, null: true
    end
  end
  def self.down
    change_table :meal_foods do |t|
      t.change :food_unit_id, :integer, null: false
      t.change :count, :integer, null: false
    end
  end
end
