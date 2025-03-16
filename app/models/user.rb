class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_one :profile, dependent: :destroy
  has_one :merchant, dependent: :destroy
  has_many :products, through: :merchant
  has_many :likes, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :order_items, through: :orders
  has_many :cart_items, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :reviews, dependent: :destroy

  # Blog associations
  has_many :posts, dependent: :nullify
  has_many :comments, dependent: :nullify
  has_many :post_views, dependent: :nullify

  delegate :first_name, :last_name, to: :profile, allow_nil: true

  has_one_attached :profi_image
  # Active Storage avatar attachment
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [ 100, 100 ]
    attachable.variant :medium, resize_to_fill: [ 300, 300 ]
  end

  # Enum for membership levels
  enum :membership_level, {
    free: 0,
    basic: 1,
    pro: 2,
    premium: 3
  }

  # Method to check if user is a merchant
  def is_merchant?
    self.merchant.present?
  end

  def admin?
    # Strategy 1: Explicit Admin Column
    return true if admin == true

    # Strategy 2: Domain-Based Admin Detection
    if email.present?
      # Option A: Specific admin domain
      return true if email.ends_with?("@youradmindomain.com")

      # Option B: Whitelist of admin email addresses
      admin_emails = [
        "kojcoder@gmail.com",
        "tech_lead@example.com",
        "founder@example.com"
      ]
      return true if admin_emails.include?(email)
    end

    # Strategy 3: Membership-Based Admin Elevation
    # Premium members get admin-like privileges
    return true if membership_level == "premium"

    # Strategy 4: Specific User IDs
    admin_user_ids = [ 1, 2, 3, 4 ]  # First few system users
    return true if admin_user_ids.include?(id)

    # Strategy 5: Role-Based (Most Flexible)
    # Requires additional role management gem like 'rolify'
    # has_role?(:admin)

    # Default: Not an admin
    false
  end

  # Complementary Method for Enhanced Authorization
  def super_admin?
    # Most restricted admin level
    email == "kojcoder@gmail.com" ||
    id == 1  # First user in the system
  end

  def pro_member?
    pro? || premium?
  end

  # # Validation for avatar upload
  # validates :avatar,
  #   content_type: [ "image/png", "image/jpeg", "image/jpg", "image/gif" ],
  #   size: { less_than: 5.megabytes }

  # Method to generate a default avatar if no image is uploaded
  def avatar_or_default
    avatar.attached? ? avatar.variant(:thumb) : default_avatar
  end

  after_create :create_profile
  # Active Storage for profile image
  has_one_attached :profile_image if respond_to?(:has_one_attached)

  # Post-related methods
  def full_name
    if first_name.present? || last_name.present?
      "#{first_name} #{last_name}".strip
    else
      name
    end
  end

  def is_author?
    posts.published.exists?
  end

  def recent_posts(limit = 5)
    posts.published.recent.limit(limit)
  end

  # Soft delete support
  default_scope { where(deleted_at: nil) }

  # Method to check if user is soft deleted
  def deleted?
    deleted_at.present?
  end

  # Soft delete method
  def soft_delete
    update(
      deleted_at: Time.current,
      email: "deleted_#{id}_#{Time.current.to_i}@example.com"
    )
  end

  # Restore a soft-deleted user
  def restore
    update(
      deleted_at: nil,
      email: email.gsub(/^deleted_\d+_\d+@/, "")
    )
  end

  # Scope for finding deleted users
  scope :only_deleted, -> { unscoped.where.not(deleted_at: nil) }

  # Override Devise's method to handle soft delete
  def active_for_authentication?
    super && !deleted?
  end

  # Optional: Add a class method to permanently delete old soft-deleted records
  def self.cleanup_deleted_users(days = 30)
    only_deleted.where("deleted_at < ?", days.days.ago).destroy_all
  end

  def profile_exists?
    profile.present?
  end

  def ensure_profile
    create_profile if profile.nil?
  end

  private

  def create_profile
    # Build a basic profile with defaults
    build_profile(
      profile_username: username,
      profile_phone_number: phone_number,
      first_name: full_name&.split(" ")&.first || "",
      last_name: full_name&.split(" ")&.drop(1)&.join(" ") || ""
    ).save
  end

  def default_avatar
    # Generate an SVG avatar with user's initials
    initial = username.present? ? username.first.upcase : email.first.upcase
    color = avatar_background_color

    # Inline SVG generation
    %(
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
        <rect width="100" height="100" fill="#{color}" />
        <text
          x="50%"
          y="50%"
          text-anchor="middle"
          dy=".3em"
          fill="white"
          font-family="Arial, sans-serif"
          font-size="40"
        >
          #{initial}
        </text>
      </svg>
    ).html_safe
  end

  def avatar_background_color
    # Generate a consistent background color based on user attributes
    colors = [
      "#1abc9c", # Turquoise
      "#2ecc71", # Emerald
      "#3498db", # Peter River
      "#9b59b6", # Amethyst
      "#34495e", # Wet Asphalt
      "#f1c40f", # Sunflower
      "#e67e22", # Carrot
      "#e74c3c"  # Alizarin
    ]

    # Use a consistent hash to generate the same color for the same user
    index = (username || email).bytes.sum % colors.length
    colors[index]
  end
end
