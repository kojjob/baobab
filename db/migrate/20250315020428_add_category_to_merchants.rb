class AddCategoryToMerchants < ActiveRecord::Migration[8.0]
  def change
    add_column :merchants, :category_id, :integer
  end
end
