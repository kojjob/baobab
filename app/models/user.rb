class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


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

  private

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
