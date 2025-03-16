class AddCoverPhotoToMerchants < ActiveRecord::Migration[8.0]
  def change
    add_column :merchants, :cover_photo, :string
  end
end
