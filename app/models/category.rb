class Category < ApplicationRecord
  # Associations
  has_many :posts, dependent: :nullify

  # Validations
  validates :name, presence: true, length: { maximum: 50 }
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/ }

  # Callbacks
  before_validation :generate_slug, if: -> { slug.blank? && name.present? }

  # Scopes
  scope :with_posts, -> { joins(:posts).distinct }

  # Methods
  def to_param
    slug
  end

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
