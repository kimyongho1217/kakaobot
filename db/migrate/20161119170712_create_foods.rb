class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string :name, null: false
      t.integer :calorie, null: false
      t.integer :weight, null: false
      t.integer :carbohydrate
      t.integer :protein
      t.integer :fat
      t.integer :sugars
      t.integer :sodium
      t.integer :cholesterol
      t.integer :saturated_fat
      t.integer :trans_fat
      t.text :description
      t.attachment  :image
      t.timestamps null: false
    end
    add_index :foods, :name
  end
end
