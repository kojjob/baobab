class PostView < ApplicationRecord
  # Associations
  belongs_to :post
  belongs_to :user, optional: true

  # Validations
  validates :ip_address, presence: true, unless: -> { user.present? }

  # Scopes
  scope :recent, -> { where("created_at > ?", 30.days.ago) }
  scope :unique_by_ip, -> { select("DISTINCT ON (ip_address) *") }
end

# Update the Post model to include the view counter
class Post < ApplicationRecord
  # Add to existing associations
  has_many :post_views, dependent: :destroy

  # Methods for analytics
  def view_count
    post_views.count
  end

  def unique_view_count
    post_views.select("DISTINCT ip_address").count
  end

  def record_view(user = nil, ip_address = nil)
    views = post_views.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)

    if user.present?
      return if views.where(user_id: user.id).exists?
      post_views.create(user: user, ip_address: ip_address)
    elsif ip_address.present?
      return if views.where(ip_address: ip_address).exists?
      post_views.create(ip_address: ip_address)
    end
  end
end
