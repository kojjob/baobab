class ChangeMetadataToJsonbInAnnouncements < ActiveRecord::Migration[8.0]
  def change
    # Change the column type from json to jsonb
    change_column :announcements, :metadata, :jsonb, default: {}
  end
end
