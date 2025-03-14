class Post < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy
  has_many :post_views, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  # Active Storage for featured image
  has_rich_text :content
  has_one_attached :featured_image


  # Validations
  validates :title, presence: true, length: { minimum: 5, maximum: 255 }
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/ }
  validates :content, presence: true

  # Callbacks
  before_validation :generate_slug, if: -> { slug.blank? && title.present? }

  # Scopes
  scope :published, -> { where(published: true).where("published_at <= ?", Time.current) }
  scope :featured, -> { where(featured: true) }
  scope :recent, -> { order(published_at: :desc) }
  scope :with_tag, ->(tag_id) { joins(:tags).where(tags: { id: tag_id }) }


  # Methods
  def to_param
    slug
  end

  def reading_time
    words_per_minute = 200
    words = content.split.size
    minutes = (words / words_per_minute).floor
    minutes = 1 if minutes < 1
    minutes
  end

  private

  def generate_slug
    # Generate a URL-friendly slug from the title
    self.slug = title.parameterize
  end
end
