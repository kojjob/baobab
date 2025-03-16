class AddAddressIndexesToAddresses < ActiveRecord::Migration[8.0]
  def change
    add_index :addresses, :address_type
  end
end
