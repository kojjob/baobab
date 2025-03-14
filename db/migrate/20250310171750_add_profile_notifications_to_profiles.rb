class AddProfileNotificationsToProfiles < ActiveRecord::Migration[8.0]
  def change
    add_column :profiles, :profile_notifications, :text
  end
end
