class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.string :profile_username
      t.string :profile_phone_number
      t.date :profile_date_of_birth
      t.text :profile_bio
      t.string :profile_location
      t.string :profile_website
      t.integer :profile_gender
      t.string :profile_language
      t.integer :profile_views_count
      t.datetime :profile_last_seen_at
      t.integer :profile_verification_status
      t.string :profile_referral_code
      t.jsonb :profile_social_links
      t.jsonb :profile_privacy_settings
      t.string :profile_tags
      t.string :profile_interests
      t.integer :profile_completion
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :profiles, :profile_username, unique: true
  end
end
