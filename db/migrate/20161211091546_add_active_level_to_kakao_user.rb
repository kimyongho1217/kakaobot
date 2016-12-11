class AddActiveLevelToKakaoUser < ActiveRecord::Migration
  def change
    add_column :kakao_users, :active_type, :integer
  end
end
