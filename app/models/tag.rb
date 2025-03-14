class Tag < ApplicationRecord
  # Associations
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  # Validations
  validates :name, presence: true, length: { maximum: 30 }
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/ }

  # Callbacks
  before_validation :generate_slug, if: -> { slug.blank? && name.present? }

  # Methods
  def to_param
    slug
  end

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
