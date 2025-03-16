class Review < ApplicationRecord
  belongs_to   :user
  belongs_to   :product, counter_cache: true
  belongs_to   :merchant, counter_cache: true
  # validates    :rating, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 6 }
  # validates    :comment, presence: true, length: { minimum: 5 }
  # validates    :user_id, uniqueness: { scope: :product_id, message: "has reviewed this product already" }
  # after_create :update_product_rating
end
