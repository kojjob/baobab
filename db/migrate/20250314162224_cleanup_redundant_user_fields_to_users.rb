class CleanupRedundantUserFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    # Remove redundant fields from users table
    remove_column :users, :full_name
    remove_column :users, :phone_number
    remove_column :users, :bio
    remove_column :users, :profile_image
    remove_column :users, :profile_completion
    remove_column :users, :profile_visibility

    # Rename phone to ensure consistency
    rename_column :users, :phone, :phone_number
  end
end
