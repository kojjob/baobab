class AddNotNullConstraints < ActiveRecord::Migration[8.0]
  def change
    # Add not null constraints to essential fields
    change_column_null :products, :name, false
    change_column_null :products, :price, false
    change_column_null :merchants, :name, false
    change_column_null :reviews, :rating, false
    change_column_null :categories, :name, false
    change_column_null :categories, :slug, false
  end
end
