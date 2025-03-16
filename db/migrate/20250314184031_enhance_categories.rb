class EnhanceCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :parent_id, :integer, null: true
    add_column :categories, :icon, :string
    add_column :categories, :position, :integer, default: 0
    add_column :categories, :featured, :boolean, default: false
    add_column :categories, :active, :boolean, default: true

    add_index :categories, :parent_id
    add_index :categories, :position
    add_index :categories, :featured
    add_index :categories, :active
  end
end
