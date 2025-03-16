class CreateAnnouncements < ActiveRecord::Migration[8.0]
  def change
    create_table :announcements do |t|
      # Core Content
      t.text :content, null: false
      t.string :title
      t.string :subtitle

      # Polymorphic Association for Flexibility
      t.references :announceable, polymorphic: true, index: true

      # Targeting and Visibility
      t.integer :domain, default: 0
      t.integer :visibility, default: 0
      t.integer :interaction_type, default: 0

      # Temporal Controls
      t.boolean :active, default: true
      t.datetime :start_date
      t.datetime :end_date

      # Rich Metadata
      t.string :action_url
      t.string :icon
      t.json :metadata, default: {}

      # Tracking and Analytics
      t.integer :priority, default: 5
      t.integer :views_count, default: 0
      t.integer :clicks_count, default: 0

      # Geospatial and Demographic Constraints
      t.string :location_constraint
      t.integer :min_age
      t.integer :max_age

      # User Segmentation
      t.string :user_segment

      # Partnership and Source
      t.references :partner
      t.string :partner_type

      t.timestamps
    end

    # Add indexes for performance
    add_index :announcements, :domain
    add_index :announcements, :visibility
    add_index :announcements, :active
    add_index :announcements, [ :start_date, :end_date ]
  end
end
