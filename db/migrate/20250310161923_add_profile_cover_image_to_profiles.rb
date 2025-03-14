class AddProfileCoverImageToProfiles < ActiveRecord::Migration[8.0]
  def change
    add_column :profiles, :profile_cover_image, :string
  end
end
