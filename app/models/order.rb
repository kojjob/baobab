class Order < ApplicationRecord
  belongs_to :user
  belongs_to :merchant

  enum :status, { pending: "pending", processing: "processing", shipped: "shipped", delivered: "delivered", cancelled: "cancelled" }
enum :payment_status, { unpaid: "unpaid", paid: "paid", refunded: "refunded" }
end
