class CreateProductImages < ActiveRecord::Migration[8.0]
  def change
    create_table :product_images do |t|
      t.string :image
      t.references :product, null: false, foreign_key: true
      t.boolean :primary

      t.timestamps
    end
  end
end
