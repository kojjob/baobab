class Profile < ApplicationRecord
  belongs_to :user

  has_one_attached :avatar
  has_one_attached :profile_cover_image

  # Soft delete scope
  default_scope { where(deleted_at: nil) }

  # Validation
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :profile_username, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9_]+\z/, message: "can only contain letters, numbers, and underscores"
    }

  # Soft delete method
  def restore!
    update(deleted_at: nil)
  end

  # Custom methods for profile completion
  def complete_percentage
    completeness = 0
    completeness += 20 if first_name.present?
    completeness += 20 if last_name.present?
    completeness += 15 if profile_bio.present?
    completeness += 15 if profile_location.present?
    completeness += 15 if profile_phone_number.present?
    completeness += 15 if profile_date_of_birth.present?
    [ completeness, 100 ].min
  end

  # Helper method to get notification preferences with defaults
  def notification_preferences
    if profile_notifications.present?
      begin
        JSON.parse(profile_notifications)
      rescue
        default_notification_preferences
      end
    else
      default_notification_preferences
    end
  end

  # Set default preferences for new profiles
  def default_notification_preferences
    {
      "email" => true,
      "push" => true,
      "in_app" => true
    }
  end
end
