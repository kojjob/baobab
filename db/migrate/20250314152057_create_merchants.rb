class CreateMerchants < ActiveRecord::Migration[8.0]
  def change
    create_table :merchants do |t|
      t.string :name
      t.text :description
      t.string :phone
      t.string :location
      t.string :logo
      t.boolean :active
      t.boolean :verified
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
