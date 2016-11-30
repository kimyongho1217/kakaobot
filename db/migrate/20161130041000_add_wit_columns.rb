class AddWitColumns < ActiveRecord::Migration
  def change
    add_column :foods, :synonyms, :string, array: true, default: []
    add_index :foods, :synonyms, using: :gin

    add_column :food_units, :synonyms, :string, array: true, default: []
    add_index :food_units, :synonyms, using: :gin
  end
end
