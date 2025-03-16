class Announcement < ApplicationRecord
  # Associations
  belongs_to :announceable, polymorphic: true, optional: true
  belongs_to :partner, optional: true

  # Enums provide type safety and clear intent
  enum :domain, {
    general: 0,         # Catch-all for general announcements
    financial: 1,        # Banking, investments, wallet-related
    social: 2,           # Community, connections, events
    commercial: 3,       # Marketplace, shopping deals
    transportation: 4,   # Rides, transit information
    entertainment: 5,    # Events, content, leisure
    community: 6,        # Local groups, neighborhood news
    health: 7,           # Healthcare, wellness
    education: 8         # Learning, skill development
  }, prefix: :announcement

  enum :visibility, {
    visible: 0,           # Visible to all users
    targeted: 1,         # Specific user segments
    personal: 2,         # Individual user recommendation
    vip: 3,              # Premium or high-value users
    internal: 4          # App-specific communications
  }, prefix: :announcement

  enum :interaction_type, {
    informational: 0,    # Just for awareness
    clickable: 1,        # Links to specific action
    actionable: 2,       # Directly triggerable within app
    promotional: 3       # Potential conversion opportunity
  }, prefix: :announcement

  # Scopes for flexible querying
  scope :currently_active, -> {
    where(active: true)
    .where("start_date <= ? AND end_date >= ?", Time.current, Time.current)
  }

  # Validations ensure data integrity
  validates :content, presence: true, length: { maximum: 1000 }
  validates :domain, presence: true
  validates :visibility, presence: true

  # Class method for intelligent recommendation
  def self.recommend_for_user(user)
    currently_active
      .select { |announcement| announcement.visible_to?(user) }
      .sort_by { |announcement| announcement.relevance_score(user) }
      .reverse
      .take(5)
  end

  # Determine if announcement is visible to a specific user
  def visible_to?(user)
    meets_age_requirement?(user) &&
    meets_segment_requirement?(user)
  end



  # Track user interactions
  def record_view!(user)
    increment!(:views_count)
    AnnouncementInteraction.create(
      announcement: self,
      user: user,
      interaction_type: "view"
    )
  end

  def record_click!(user)
    increment!(:clicks_count)
    AnnouncementInteraction.create(
      announcement: self,
      user: user,
      interaction_type: "click"
    )
  end

  private

  def meets_domain_requirement?(user)
    # Example logic for domain-specific visibility
    case announcement_domain
    when "financial_domain"
      user.financial_interest?
    when "social_domain"
      user.social_active?
    # Add more domain-specific logic as needed
    when "commercial_domain"
      user.shopping_interest?
    when "transportation_domain"
      user.transportation_interest?
    when "entertainment_domain"
      user.entertainment_interest?
    when "community_domain"
      user.community_interest?
    when "health_domain"
      user.health_interest?
    when "education_domain"
      user.education_interest?
    else
      true
    end
  end

  # Calculate relevance score for personalization
  def relevance_score(user)
    score = 0

    # Domain relevance
    score += 10 if user.recent_interactions.include?(domain)

    # Interaction type weight
    score += case interaction_type
    when "actionable" then 5
    when "promotional" then 3
    else 1
    end

    # Metadata-based personalization
    score += custom_relevance_logic(user)

    score
  end

  def meets_age_requirement?(user)
    return true if min_age.nil? && max_age.nil?
    user.age.between?(min_age || 0, max_age || 200)
  end

  def meets_segment_requirement?(user)
    return true if user_segment.nil?
    user.segment == user_segment
  end

  def meets_location_requirement?(user)
    return true if location_constraint.nil?
    user.location == location_constraint
  end

  def custom_relevance_logic(user)
    return 0 unless metadata.is_a?(Hash)

    matching_interests = metadata["interests"]&.intersection(user.interests || []) || []
    matching_interests.size * 2
  end
end
