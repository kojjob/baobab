class EnhanceMerchantModelToMerchants < ActiveRecord::Migration[8.0]
  def change
    # Business Information
    add_column :merchants, :registration_number, :string
    add_column :merchants, :tax_id, :string
    add_column :merchants, :business_type, :string
    add_column :merchants, :year_established, :integer
    add_column :merchants, :employee_count, :integer

    # Operational Details
    add_column :merchants, :business_hours, :jsonb, default: {}
    add_column :merchants, :delivery_radius, :decimal, precision: 5, scale: 2
    add_column :merchants, :delivery_fee, :decimal, precision: 10, scale: 2
    add_column :merchants, :minimum_order, :decimal, precision: 10, scale: 2
    add_column :merchants, :preparation_time, :integer
    add_column :merchants, :service_areas, :jsonb, default: []

    # Financial Details
    add_column :merchants, :payment_methods, :jsonb, default: []
    add_column :merchants, :commission_rate, :decimal, precision: 5, scale: 2
    add_column :merchants, :bank_account, :jsonb, default: {}, null: false
    add_column :merchants, :mobile_money_details, :jsonb, default: {}, null: false
    add_column :merchants, :payout_schedule, :string, default: 'weekly'

    # Verification & Status
    add_column :merchants, :verification_status, :string, default: 'pending'
    add_column :merchants, :featured, :boolean, default: false
    add_column :merchants, :subscription_level, :string, default: 'basic'
    add_column :merchants, :subscription_expires_at, :datetime

    # SEO & Discoverability
    add_column :merchants, :slug, :string
    add_column :merchants, :meta_title, :string
    add_column :merchants, :meta_description, :text
    add_column :merchants, :keywords, :string, array: true, default: []

    # Social & Contact
    add_column :merchants, :website, :string
    add_column :merchants, :email, :string
    add_column :merchants, :social_media, :jsonb, default: {}
    add_column :merchants, :contact_person, :string

    # Add indices for frequently queried fields
    add_index :merchants, :slug, unique: true
    add_index :merchants, :featured
    add_index :merchants, :business_type
    add_index :merchants, :subscription_level
  end
end
