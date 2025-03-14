# app/helpers/profiles_helper.rb
module ProfilesHelper
  # Determines if the date of birth should be shown based on privacy settings
  def show_dob?(profile)
    return true if current_user && current_user.id == profile.user_id

    # Check privacy settings if they exist
    if profile.profile_privacy_settings.present?
      privacy_settings = profile.profile_privacy_settings
      return privacy_settings["show_dob"] == true
    end

    # Default to false if no privacy settings
    false
  end

  # Determines if phone number should be visible based on privacy settings
  def can_view_phone?(profile)
    return true if current_user && current_user.id == profile.user_id

    # Check privacy settings if they exist
    if profile.profile_privacy_settings.present?
      privacy_settings = profile.profile_privacy_settings

      case privacy_settings["phone_visibility"]
      when "public"
        return true
      when "followers"
        return current_user && is_following?(current_user.id, profile.user_id)
      when "none"
        return false
      else
        return false
      end
    end

    # Default to false if no privacy settings
    false
  end

  # Helper to check if a user is following another user
  def is_following?(follower_id, followed_id)
    # This would need to be implemented based on your following system
    # Example: Follow.where(follower_id: follower_id, followed_id: followed_id).exists?
    false
  end

  # Format the gender text for display
  def format_gender(gender_value)
    return "Not specified" if gender_value.nil?

    case gender_value
    when 0
      "Male"
    when 1
      "Female"
    when 2
      "Non-binary"
    when 3
      "Other"
    when 4
      "Prefer not to say"
    else
      "Not specified"
    end
  end

  # Format verification status for display
  def verification_status_text(status)
    return "Not verified" if status.nil?

    case status
    when 0
      "Not verified"
    when 1
      "Email verified"
    when 2
      "Phone verified"
    when 3
      "ID verified"
    else
      "Unknown status"
    end
  end

  # Get the verification badge class based on verification status
  def verification_badge_class(status)
    return "bg-gray-400" if status.nil? || status == 0

    case status
    when 1
      "bg-blue-500"
    when 2
      "bg-green-500"
    when 3
      "bg-purple-500"
    else
      "bg-gray-400"
    end
  end
end
