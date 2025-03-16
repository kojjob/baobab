class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.references :addressable, polymorphic: true, null: true
      t.string :street_address, null: false
      t.string :address_line_2
      t.string :city, null: false
      t.string :region, null: false
      t.string :postal_code
      t.string :country, default: "Ghana"
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.text :directions
      t.integer :address_type, default: 0
      t.boolean :verified, default: false
      t.jsonb :metadata

      t.timestamps
    end

    add_index :addresses, [ :addressable_type, :addressable_id ]
  end
end
