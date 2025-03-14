class AddPrecisionToMonetaryFields < ActiveRecord::Migration[8.0]
  def change
    change_column :products, :price, :decimal, precision: 10, scale: 2
    change_column :orders, :total_amount, :decimal, precision: 10, scale: 2
    change_column :order_items, :unit_price, :decimal, precision: 10, scale: 2
  end
end
