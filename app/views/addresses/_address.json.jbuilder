json.extract! address, :id, :addressable_id, :addressable_type, :street_address, :address_line_2, :city, :region, :postal_code, :country, :latitude, :longitude, :directions, :address_type, :verified, :metadata, :created_at, :updated_at
json.url address_url(address, format: :json)
