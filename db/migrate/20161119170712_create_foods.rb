class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string    :name, null: false
      t.integer   :calorie
      t.text      :description
      t.attachment  :image
      t.timestamps null: false
    end
    add_index :foods, :name
  end
end
