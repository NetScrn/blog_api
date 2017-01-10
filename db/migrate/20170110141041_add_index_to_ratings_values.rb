class AddIndexToRatingsValues < ActiveRecord::Migration[5.0]
  def change
    add_index :ratings, :value
  end
end
