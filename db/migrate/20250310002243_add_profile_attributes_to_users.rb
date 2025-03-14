class AddProfileAttributesToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :full_name, :string
    add_column :users, :phone_number, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :region, :string
    add_column :users, :city, :string
    add_column :users, :address, :text
    add_column :users, :profile_completion, :integer
    add_column :users, :profile_visibility, :integer
    add_column :users, :last_login_at, :datetime
  end
end
