class AddConsistentSoftDeletes < ActiveRecord::Migration[8.0]
  def change
    # Add deleted_at to tables that should support soft deletes
    add_column :merchants, :deleted_at, :datetime
    add_column :products, :deleted_at, :datetime
    add_column :posts, :deleted_at, :datetime
    add_column :orders, :deleted_at, :datetime

    # Add indices for efficient querying of non-deleted records
    add_index :merchants, :deleted_at
    add_index :products, :deleted_at
    add_index :posts, :deleted_at
    add_index :orders, :deleted_at
    add_index :users, :deleted_at
    add_index :profiles, :deleted_at
    add_index :subscriptions, :deleted_at
  end
end
