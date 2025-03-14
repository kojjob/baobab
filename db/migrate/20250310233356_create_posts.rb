class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :slug
      t.text :excerpt
      t.text :content
      t.boolean :published
      t.datetime :published_at
      t.string :featured_image
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
    add_index :posts, :slug, unique: true
  end
end
