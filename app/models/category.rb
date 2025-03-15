class Category < ApplicationRecord
  # Associations
  has_many :subcategories, class_name: "Category", foreign_key: :parent_id, dependent: :destroy
  belongs_to :parent, class_name: "Category", optional: true
  has_many :posts, dependent: :nullify
  has_many :product_categories, dependent: :destroy
  has_many :products, through: :product_categories


  # Validations
  validates :name, presence: true, length: { maximum: 50 }
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/ }

  # Callbacks
  before_validation :generate_slug, if: -> { slug.blank? && name.present? }

  # Scopes
  scope :with_posts, -> { joins(:posts).distinct }
  scope :main_categories, -> { where(parent_id: nil) }
  scope :active, -> { where(active: true) }
  scope :featured, -> { where(featured: true) }
  scope :sorted, -> { order(position: :asc) }

  # Instance Methods
  def has_subcategories?
    subcategories.exists?
  end

  def root?
    parent_id.nil?
  end

  def ancestors
    category = self
    ancestors = []

    while category.parent
      ancestors << category.parent
      category = category.parent
    end

    ancestors.reverse
  end

  def to_param
    slug
  end

  def self.nested_set
    categories = {}
    main = main_categories.sorted.includes(:subcategories)

    main.each do |category|
      categories[category] = category.subcategories.sorted
    end

    categories
  end

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
