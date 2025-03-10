module ApplicationHelper
  # User Authentication Helpers
  def user_signed_in?
    current_user.present? &&
    !current_user.deleted? &&
    current_user.active_for_authentication?
  rescue NoMethodError
    # Fallback to Devise's default method
    super
  end

  # User Display Name Helpers
  def safe_user_display_name(user = current_user)
    return "Guest" unless user

    user.full_name.presence ||
    (user.username.presence if user.respond_to?(:username)) ||
    (user.email.split("@").first if user.email) ||
    "User"
  end

  # User Avatar Helpers
  def user_avatar(user = current_user, size: :thumb)
    return default_avatar_svg unless user

    if user.respond_to?(:avatar) && user.avatar.attached?
      image_tag user.avatar.variant(size),
        class: "w-10 h-10 rounded-full object-cover",
        alt: "#{safe_user_display_name(user)} avatar"
    else
      default_avatar_svg(user)
    end
  end

  def default_avatar_svg(user = nil)
    initial = extract_user_initial(user)
    color = avatar_background_color(user)

    %(
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" class="w-10 h-10 rounded-full">
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

  private

  # Color Generation
  def avatar_background_color(user = nil)
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
    identifier = extract_user_identifier(user)
    index = identifier.bytes.sum % colors.length
    colors[index]
  end

  # Extract User Identifier
  def extract_user_identifier(user = nil)
    return "default" unless user

    user.username.presence ||
    user.email.presence ||
    "default"
  end

  # Extract User Initial
  def extract_user_initial(user = nil)
    return "U" unless user

    if user.respond_to?(:username) && user.username.present?
      user.username.first.upcase
    elsif user.email.present?
      user.email.first.upcase
    else
      "U"
    end
  end
end
