class AddMembershipLevelToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :membership_level, :string
    add_column :users, :last_upgraded_at, :datetime
  end
end
