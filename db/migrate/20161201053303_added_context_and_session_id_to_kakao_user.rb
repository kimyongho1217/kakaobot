class AddedContextAndSessionIdToKakaoUser < ActiveRecord::Migration
  def change
    add_column :kakao_users, :context, :json
    add_column :kakao_users, :session_id, :string
    add_index :kakao_users, :session_id
  end
end
