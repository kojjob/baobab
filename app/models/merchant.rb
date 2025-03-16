class Merchant < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

  has_one_attached :logo
  has_many_attached :verification_documents
  has_many_attached :cover_photo

  has_many :products, dependent: :destroy
  has_many :orders
  has_many :reviews, through: :products
  has_many :announcements, as: :announceable, dependent: :destroy
  has_many :addresses, as: :addressable, dependent: :destroy

  # Validations
  validates :name, presence: true
  # validates :phone, presence: true,
  #           format: { with: /\A\+233\d{9}\z/, message: "must be a valid Ghana phone number" }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :slug, uniqueness: true, allow_nil: true
  validates :delivery_radius, numericality: { greater_than: 0 }, allow_nil: true
  validates :commission_rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
  validates :preparation_time, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  # Enums
  enum :business_type, {
    individual: "individual",
    sole_proprietorship: "sole_proprietorship",
    partnership: "partnership",
    limited_liability: "limited_liability",
    corporation: "corporation",
    cooperative: "cooperative"
  }, prefix: true

  enum :verification_status, {
    pending: "pending",
    submitted: "submitted",
    under_review: "under_review",
    approved: "approved",
    rejected: "rejected"
  }, prefix: true

  enum :payout_schedule, {
    daily: "daily",
    weekly: "weekly",
    biweekly: "biweekly",
    monthly: "monthly"
  }, prefix: true

  enum :subscription_level, {
    basic: "basic",
    standard: "standard",
    premium: "premium",
    enterprise: "enterprise"
  }, prefix: true

  # Callbacks
  before_validation :generate_slug, if: -> { slug.blank? && name.present? }
  before_save :encrypt_sensitive_information

  # Scopes
  scope :active, -> { where(active: true) }
  scope :verified, -> { where(verified: true) }
  scope :featured, -> { where(featured: true) }
  scope :by_category, ->(category_id) { where(category_id: category_id) }
  scope :by_business_type, ->(type) { where(business_type: type) }
  scope :by_subscription, ->(level) { where(subscription_level: level) }
  scope :delivery_available, -> { where.not(delivery_radius: nil) }

  # For location-based queries using PostGIS (if available)
  # scope :near, ->(latitude, longitude, radius_km = 5) {
  #   where("ST_DWithin(location::geography, ST_MakePoint(:lon, :lat)::geography, :radius)",
  #         lat: latitude, lon: longitude, radius: radius_km * 1000)
  # }

  # Search functionality
  include PgSearch::Model
  pg_search_scope :search_by_name_and_description,
                  against: [ :name, :description, :keywords ],
                  using: {
                    tsearch: { prefix: true }
                  }

  # Methods

  # Method to get the current active announcement
  # Address convenience methods
  def primary_address
    addresses.where(address_type: :physical).first
  end

  def directions
    primary_address&.directions
  end

  def address
    primary_address&.street_address
  end

  def city
    primary_address&.city
  end

  def region
    primary_address&.region
  end


  def announcement
    announcements.where(active: true)
                 .where("start_date <= ? AND end_date >= ?", Time.current, Time.current)
                 .order(created_at: :desc)
                 .first
  end

  def average_rating
    reviews.average(:rating) || 0
  end

  def reviews_count
    reviews.count
  end

  def update_rating
    update_column(:average_rating, average_rating)
  end

  def rating_percentage(rating)
    return 0 if reviews_count == 0

    ((reviews.where(rating: rating).count.to_f / reviews_count) * 100).round
  end

  def available_payment_methods
    if payment_methods.blank?
      # Default to most common payment methods in Ghana if none specified
      [ "mobile_money", "cash_on_delivery" ]
    else
      payment_methods
    end
  end

  def business_hours_for_day(day)
    return nil unless business_hours.present?

    day_key = day.to_s.downcase
    return nil unless business_hours[day_key].present?

    business_hours[day_key]
  end

  def open_now?
    return false unless business_hours.present?

    now = Time.current
    day_name = now.strftime("%A").downcase

    return false unless business_hours[day_name].present? && business_hours[day_name]["open"]

    open_time = Time.parse(business_hours[day_name]["open_time"])
    close_time = Time.parse(business_hours[day_name]["close_time"])

    current_time = now.strftime("%H:%M")
    current_time >= open_time.strftime("%H:%M") && current_time <= close_time.strftime("%H:%M")
  end

  def subscription_active?
    subscription_expires_at.nil? || subscription_expires_at > Time.current
  end

  def can_feature_products?
    subscription_level.in?([ "standard", "premium", "enterprise" ]) && subscription_active?
  end

  def verification_complete?
    verified? && verification_status_approved?
  end

  private

  def generate_slug
    self.slug = name.parameterize

    # Ensure uniqueness
    counter = 1
    original_slug = slug
    while Merchant.exists?(slug: slug)
      self.slug = "#{original_slug}-#{counter}"
      counter += 1
    end
  end

  def encrypt_sensitive_information
    # Implement encryption for sensitive fields like bank_account and mobile_money_details
    # Example implementation using Active Record Encryption (Rails 7+)
    # self.bank_account_encrypted = encrypt_and_sign(bank_account.to_json) if bank_account_changed?
    # self.mobile_money_details_encrypted = encrypt_and_sign(mobile_money_details.to_json) if mobile_money_details_changed?
  end
end
