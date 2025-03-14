class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :content, null: false
      t.integer :status, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.bigint :parent_id, null: true  # Changed to bigint directly

      t.timestamps
    end

    add_index :comments, :parent_id  # Add index manually
    add_foreign_key :comments, :comments, column: :parent_id  # Add foreign key manually
  end
end
