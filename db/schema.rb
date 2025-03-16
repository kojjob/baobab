# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_03_16_113055) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "addressable_type"
    t.bigint "addressable_id"
    t.string "street_address", null: false
    t.string "address_line_2"
    t.string "city", null: false
    t.string "region", null: false
    t.string "postal_code"
    t.string "country", default: "Ghana"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.text "directions"
    t.integer "address_type", default: 0
    t.boolean "verified", default: false
    t.jsonb "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_type"], name: "index_addresses_on_address_type"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id"
  end

  create_table "announcements", force: :cascade do |t|
    t.text "content", null: false
    t.string "title"
    t.string "subtitle"
    t.string "announceable_type"
    t.bigint "announceable_id"
    t.integer "domain", default: 0
    t.integer "visibility", default: 0
    t.integer "interaction_type", default: 0
    t.boolean "active", default: true
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "action_url"
    t.string "icon"
    t.jsonb "metadata", default: {}
    t.integer "priority", default: 5
    t.integer "views_count", default: 0
    t.integer "clicks_count", default: 0
    t.string "location_constraint"
    t.integer "min_age"
    t.integer "max_age"
    t.string "user_segment"
    t.bigint "partner_id"
    t.string "partner_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_announcements_on_active"
    t.index ["announceable_type", "announceable_id"], name: "index_announcements_on_announceable"
    t.index ["partner_id"], name: "index_announcements_on_partner_id"
    t.index ["start_date", "end_date"], name: "index_announcements_on_start_date_and_end_date"
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
  end

  create_table "carts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
    t.string "icon"
    t.integer "position", default: 0
    t.boolean "featured", default: false
    t.boolean "active", default: true
    t.index ["active"], name: "index_categories_on_active"
    t.index ["featured"], name: "index_categories_on_featured"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["position"], name: "index_categories_on_position"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.text "content", null: false
    t.integer "status", default: 0
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_comments_on_parent_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "phone"
    t.string "location"
    t.string "logo"
    t.boolean "active"
    t.boolean "verified"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "registration_number"
    t.string "tax_id"
    t.string "business_type"
    t.integer "year_established"
    t.integer "employee_count"
    t.jsonb "business_hours", default: {}
    t.decimal "delivery_radius", precision: 5, scale: 2
    t.decimal "delivery_fee", precision: 10, scale: 2
    t.decimal "minimum_order", precision: 10, scale: 2
    t.integer "preparation_time"
    t.jsonb "service_areas", default: []
    t.jsonb "payment_methods", default: []
    t.decimal "commission_rate", precision: 5, scale: 2
    t.jsonb "bank_account", default: {}, null: false
    t.jsonb "mobile_money_details", default: {}, null: false
    t.string "payout_schedule", default: "weekly"
    t.string "verification_status", default: "pending"
    t.boolean "featured", default: false
    t.string "subscription_level", default: "basic"
    t.datetime "subscription_expires_at"
    t.string "slug"
    t.string "meta_title"
    t.text "meta_description"
    t.string "keywords", default: [], array: true
    t.string "website"
    t.string "email"
    t.jsonb "social_media", default: {}
    t.string "contact_person"
    t.integer "category_id"
    t.string "cover_photo"
    t.text "return_policy"
    t.text "shipping_policy"
    t.index ["active"], name: "index_merchants_on_active"
    t.index ["business_type"], name: "index_merchants_on_business_type"
    t.index ["deleted_at"], name: "index_merchants_on_deleted_at"
    t.index ["featured"], name: "index_merchants_on_featured"
    t.index ["slug"], name: "index_merchants_on_slug", unique: true
    t.index ["subscription_level"], name: "index_merchants_on_subscription_level"
    t.index ["user_id"], name: "index_merchants_on_user_id"
    t.index ["verified"], name: "index_merchants_on_verified"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.decimal "unit_price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "merchant_id", null: false
    t.decimal "total_amount", precision: 10, scale: 2
    t.string "reference"
    t.text "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.integer "payment_status", default: 0
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_orders_on_deleted_at"
    t.index ["merchant_id"], name: "index_orders_on_merchant_id"
    t.index ["payment_status"], name: "index_orders_on_payment_status"
    t.index ["status"], name: "index_orders_on_status"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "post_tags", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_tags_on_post_id"
    t.index ["tag_id"], name: "index_post_tags_on_tag_id"
  end

  create_table "post_views", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "viewed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_views_on_post_id"
    t.index ["user_id"], name: "index_post_views_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.text "excerpt"
    t.text "content"
    t.boolean "published"
    t.datetime "published_at"
    t.string "featured_image"
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["category_id"], name: "index_posts_on_category_id"
    t.index ["deleted_at"], name: "index_posts_on_deleted_at"
    t.index ["published"], name: "index_posts_on_published"
    t.index ["published_at"], name: "index_posts_on_published_at"
    t.index ["slug"], name: "index_posts_on_slug", unique: true
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "product_categories", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_product_categories_on_category_id"
    t.index ["product_id"], name: "index_product_categories_on_product_id"
  end

  create_table "product_images", force: :cascade do |t|
    t.string "image"
    t.bigint "product_id", null: false
    t.boolean "primary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_images_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.decimal "price", precision: 10, scale: 2, null: false
    t.integer "stock_quantity"
    t.boolean "active"
    t.bigint "merchant_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["active"], name: "index_products_on_active"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["deleted_at"], name: "index_products_on_deleted_at"
    t.index ["merchant_id"], name: "index_products_on_merchant_id"
    t.index ["price"], name: "index_products_on_price"
    t.index ["stock_quantity"], name: "index_products_on_stock_quantity"
    t.check_constraint "price >= 0::numeric", name: "check_product_price_positive"
    t.check_constraint "stock_quantity >= 0", name: "check_product_stock_positive"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "phone_number"
    t.date "date_of_birth"
    t.text "bio"
    t.string "profile_location"
    t.string "profile_website"
    t.integer "profile_gender"
    t.string "profile_language"
    t.integer "profile_views_count"
    t.datetime "profile_last_seen_at"
    t.integer "profile_verification_status"
    t.string "profile_referral_code"
    t.jsonb "profile_social_links"
    t.jsonb "profile_privacy_settings"
    t.string "profile_tags"
    t.string "profile_interests"
    t.integer "profile_completion"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "profile_cover_image"
    t.text "profile_notifications"
    t.index ["deleted_at"], name: "index_profiles_on_deleted_at"
    t.index ["profile_last_seen_at"], name: "index_profiles_on_profile_last_seen_at"
    t.index ["user_id"], name: "index_profiles_on_user_id"
    t.index ["username"], name: "index_profiles_on_username", unique: true
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "product_id", null: false
    t.integer "rating", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_reviews_on_product_id"
    t.index ["rating"], name: "index_reviews_on_rating"
    t.index ["user_id"], name: "index_reviews_on_user_id"
    t.check_constraint "rating >= 1 AND rating <= 5", name: "check_review_rating_range"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "email"
    t.integer "status"
    t.bigint "user_id", null: false
    t.datetime "cancelled_at"
    t.datetime "ended_at"
    t.datetime "started_at"
    t.datetime "trial_ended_at"
    t.datetime "trial_started_at"
    t.datetime "deleted_at"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_subscriptions_on_deleted_at"
    t.index ["email"], name: "index_subscriptions_on_email", unique: true
    t.index ["token"], name: "index_subscriptions_on_token", unique: true
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_tags_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", default: "", null: false
    t.string "username", default: "", null: false
    t.string "phone_number", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "terms_of_service", default: false
    t.datetime "deleted_at"
    t.string "membership_level"
    t.datetime "last_upgraded_at"
    t.date "date_of_birth"
    t.string "region"
    t.string "city"
    t.text "address"
    t.datetime "last_login_at"
    t.boolean "admin", default: false
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["last_login_at"], name: "index_users_on_last_login_at"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.check_constraint "email::text ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'::text", name: "check_email_format"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "products"
  add_foreign_key "carts", "users"
  add_foreign_key "comments", "comments", column: "parent_id"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "merchants", "users"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "merchants"
  add_foreign_key "orders", "users"
  add_foreign_key "post_tags", "posts"
  add_foreign_key "post_tags", "tags"
  add_foreign_key "post_views", "posts"
  add_foreign_key "post_views", "users"
  add_foreign_key "posts", "categories"
  add_foreign_key "posts", "users"
  add_foreign_key "product_categories", "categories"
  add_foreign_key "product_categories", "products"
  add_foreign_key "product_images", "products"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "merchants"
  add_foreign_key "profiles", "users"
  add_foreign_key "reviews", "products"
  add_foreign_key "reviews", "users"
  add_foreign_key "subscriptions", "users"
end
