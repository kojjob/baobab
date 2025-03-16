class AddPolicyFieldsToMerchants < ActiveRecord::Migration[8.0]
  def change
    add_column :merchants, :return_policy, :text
    add_column :merchants, :shipping_policy, :text
  end
end
