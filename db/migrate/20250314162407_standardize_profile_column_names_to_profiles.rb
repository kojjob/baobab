class StandardizeProfileColumnNamesToProfiles < ActiveRecord::Migration[8.0]
  def change
    rename_column :profiles, :profile_username, :username
    rename_column :profiles, :profile_phone_number, :phone_number
    rename_column :profiles, :profile_date_of_birth, :date_of_birth
    rename_column :profiles, :profile_bio, :bio
    # ... rename other profile_ prefixed columns
  end
end
