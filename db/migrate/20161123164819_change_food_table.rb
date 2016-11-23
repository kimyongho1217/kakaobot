class ChangeFoodTable < ActiveRecord::Migration
  def up
    drop_table :foods
    create_table :foods do |t|
      t.string :name, null: false
      t.decimal :weight, null: false
      t.decimal :calorie, null: false
      t.decimal :carbohydrate
      t.decimal :protein
      t.decimal :fat
      t.decimal :sugars
      t.decimal :sodium
      t.decimal :cholesterol
      t.decimal :saturated_fat
      t.decimal :trans_fat
      t.text :description
      t.attachment  :image
      t.timestamps null: false
    end
    add_index :foods, :name, unique: true
  end
  def down
    drop_table :foods
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
