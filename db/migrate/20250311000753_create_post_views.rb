class CreatePostViews < ActiveRecord::Migration[8.0]
  def change
    create_table :post_views do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :ip_address
      t.string :user_agent
      t.datetime :viewed_at

      t.timestamps
    end
  end
end
