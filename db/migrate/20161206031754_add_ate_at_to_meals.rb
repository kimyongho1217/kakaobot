class AddAteAtToMeals < ActiveRecord::Migration
  def change
    add_column :meals, :ate_at, :datetime
    add_index :meals, :ate_at
  end
end
