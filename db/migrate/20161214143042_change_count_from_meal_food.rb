class ChangeCountFromMealFood < ActiveRecord::Migration
  def self.up
    change_table :meal_foods do |t|
      t.change :count, :decimal, null: true
    end
  end
  def self.down
    change_table :meal_foods do |t|
      t.change :count, :integer, null: true
    end
  end
end
