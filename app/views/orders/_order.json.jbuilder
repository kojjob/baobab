json.extract! order, :id, :user_id, :merchant_id, :status, :total_amount, :payment_status, :reference, :address, :created_at, :updated_at
json.url order_url(order, format: :json)
