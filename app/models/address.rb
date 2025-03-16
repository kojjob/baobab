class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true, optional: true

  # Validations
  validates :street_address, presence: true
  validates :city, presence: true
  validates :region, presence: true
  validates :postal_code, presence: true, if: -> { country != "Ghana" } # Optional for Ghana

  # Enums for address types
  enum :address_type, {
    physical: 0,    # Physical location
    mailing: 1,     # Postal address
    billing: 2,     # For invoices
    shipping: 3,    # For deliveries
    headquarters: 4 # Main office
  }, prefix: "address"

  # Geocoding could be added here for map functionality

  # Helper methods for formatting
  def full_address
    [ street_address, address_line_2, city, region, postal_code, country ].compact.join(", ")
  end

  def directions
    # Could contain custom directions text or be generated based on landmarks
  end
end
