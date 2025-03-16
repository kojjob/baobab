class UpdateAnnouncementIndexes < ActiveRecord::Migration[8.0]
  def change
    # Safely remove existing indexes if they exist
    remove_index :announcements, :domain if index_exists?(:announcements, :domain)
    remove_index :announcements, :visibility if index_exists?(:announcements, :visibility)


    # Existing active and compound indexes
    add_index :announcements, :active unless index_exists?(:announcements, :active)
    add_index :announcements, [ :start_date, :end_date ] unless index_exists?(:announcements, [ :start_date, :end_date ])
  end
end
