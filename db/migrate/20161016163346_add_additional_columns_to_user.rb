class AddAdditionalColumnsToUser < ActiveRecord::Migration
  def change
		add_column :users, :admin, :boolean, default: false
		add_column :users, :api_token, :string, default: ""
		add_index :users, :api_token,   unique: true
  end
end
