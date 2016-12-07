class RemoveContextFromKakaoUser < ActiveRecord::Migration
  def change
    remove_column :kakao_users, :context
  end
end
