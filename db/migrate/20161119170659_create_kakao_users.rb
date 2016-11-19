class CreateKakaoUsers < ActiveRecord::Migration
  def change
    create_table :kakao_users do |t|
      t.string      :user_key, null: false
      t.boolean     :active, null: false, default: true
      t.integer     :age
      t.integer     :height
      t.integer     :weight
      t.integer     :daily_calorie_consumption
      t.timestamps null: false
    end
    add_index :kakao_users, :user_key
  end
end
