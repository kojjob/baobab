class AddMissingIndices < ActiveRecord::Migration[8.0]
  def change
    # Frequently filtered fields
    add_index :products, :active
    add_index :merchants, :active
    add_index :merchants, :verified
    add_index :posts, :published

    # Date fields often used in ranges
    add_index :posts, :published_at
    add_index :users, :last_login_at
    add_index :profiles, :profile_last_seen_at

    # Fields used in sorting or filtering
    add_index :products, :price
    add_index :products, :stock_quantity
    add_index :reviews, :rating
  end
end
