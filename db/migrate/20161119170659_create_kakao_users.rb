class CreateKakaoUsers < ActiveRecord::Migration
  def change
    create_table :kakao_users do |t|
      t.string      :user_key, null: false
      t.boolean     :active, null: false, default: true
      t.string      :sex
      t.integer     :age
      t.integer     :height
      t.integer     :weight
      t.integer     :recommended_calories, default: 0
      t.timestamps null: false
    end
    add_index :kakao_users, :user_key
  end
end
