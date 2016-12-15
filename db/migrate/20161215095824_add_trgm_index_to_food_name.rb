class AddTrgmIndexToFoodName < ActiveRecord::Migration
  def up
    enable_extension :pg_trgm
    execute "CREATE INDEX trgm_index_foods_on_name ON foods USING gin(name gin_trgm_ops)"
  end

  def down
    execute "DROP INDEX trgm_index_foods_on_name"
  end
end
