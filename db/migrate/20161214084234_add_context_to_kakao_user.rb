class AddContextToKakaoUser < ActiveRecord::Migration
  def change
    add_column :kakao_users, :context, :json
  end
end
