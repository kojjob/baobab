class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :merchant, null: false, foreign_key: true
      t.string :status
      t.decimal :total_amount
      t.string :payment_status
      t.string :reference
      t.text :address

      t.timestamps
    end
  end
end
