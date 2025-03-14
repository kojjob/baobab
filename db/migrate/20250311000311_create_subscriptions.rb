class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.string :email
      t.integer :status
      t.references :user, null: false, foreign_key: true
      t.datetime :cancelled_at
      t.datetime :ended_at
      t.datetime :started_at
      t.datetime :trial_ended_at
      t.datetime :trial_started_at
      t.datetime :deleted_at
      t.string :token

      t.timestamps
    end
    add_index :subscriptions, :email, unique: true
    add_index :subscriptions, :token, unique: true
  end
end
