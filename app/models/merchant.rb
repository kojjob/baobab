class Merchant < ApplicationRecord
  belongs_to :user
  has_one_attached :logo
  has_many :products, dependent: :destroy
  has_many :orders, through: :products
  has_many :order_items, through: :orders
  has_many :reviews, through: :products
  has_many :likes, through: :products
  has_many :categories, through: :products
end
