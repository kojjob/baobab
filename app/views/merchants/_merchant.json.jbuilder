json.extract! merchant, :id, :name, :description, :phone, :location, :logo, :active, :verified, :user_id, :created_at, :updated_at
json.url merchant_url(merchant, format: :json)
