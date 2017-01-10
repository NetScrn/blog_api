class AddAveCacheToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :ave_cache, :float
    add_index :posts, :ave_cache
  end
end
