class CreateRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :ratings do |t|
      t.integer :value
      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end
