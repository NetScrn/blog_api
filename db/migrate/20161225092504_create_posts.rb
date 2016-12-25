class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :content
      t.string :author_ip
      t.references :author, foreign_key: {to_table: :users}

      t.timestamps
    end

    add_index :posts, :author_ip
  end
end
