class Product < ApplicationRecord
  # Associations
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items
  has_many :reviews, dependent: :destroy
  has_many_attached :images
  belongs_to :merchant
  belongs_to :category

  # Scopes
  scope :active, -> { where(active: true) }
  scope :in_stock, -> { where("stock_quantity > 0") }
  scope :featured, -> { where(featured: true) }
  scope :latest, -> { order(created_at: :desc) }
  scope :price_asc, -> { order(price: :asc) }
  scope :price_desc, -> { order(price: :desc) }

  # Combined scopes
  scope :available, -> { active.in_stock }
  scope :latest_active, -> { active.latest }
  scope :featured_active, -> { active.featured }

  # Validations
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
