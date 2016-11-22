class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.references  :kakao_user, null: false
      t.integer     :total_calorie_consumption, default: 0
      t.timestamps null: false
    end
    add_index :meals, :kakao_user_id
  end
end
