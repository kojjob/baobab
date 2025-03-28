require "application_system_test_case"

class AddressesTest < ApplicationSystemTestCase
  setup do
    @address = addresses(:one)
  end

  test "visiting the index" do
    visit addresses_url
    assert_selector "h1", text: "Addresses"
  end

  test "should create address" do
    visit addresses_url
    click_on "New address"

    fill_in "Address line 2", with: @address.address_line_2
    fill_in "Address type", with: @address.address_type
    fill_in "Addressable", with: @address.addressable_id
    fill_in "Addressable type", with: @address.addressable_type
    fill_in "City", with: @address.city
    fill_in "Country", with: @address.country
    fill_in "Directions", with: @address.directions
    fill_in "Latitude", with: @address.latitude
    fill_in "Longitude", with: @address.longitude
    fill_in "Metadata", with: @address.metadata
    fill_in "Postal code", with: @address.postal_code
    fill_in "Region", with: @address.region
    fill_in "Street address", with: @address.street_address
    check "Verified" if @address.verified
    click_on "Create Address"

    assert_text "Address was successfully created"
    click_on "Back"
  end

  test "should update Address" do
    visit address_url(@address)
    click_on "Edit this address", match: :first

    fill_in "Address line 2", with: @address.address_line_2
    fill_in "Address type", with: @address.address_type
    fill_in "Addressable", with: @address.addressable_id
    fill_in "Addressable type", with: @address.addressable_type
    fill_in "City", with: @address.city
    fill_in "Country", with: @address.country
    fill_in "Directions", with: @address.directions
    fill_in "Latitude", with: @address.latitude
    fill_in "Longitude", with: @address.longitude
    fill_in "Metadata", with: @address.metadata
    fill_in "Postal code", with: @address.postal_code
    fill_in "Region", with: @address.region
    fill_in "Street address", with: @address.street_address
    check "Verified" if @address.verified
    click_on "Update Address"

    assert_text "Address was successfully updated"
    click_on "Back"
  end

  test "should destroy Address" do
    visit address_url(@address)
    click_on "Destroy this address", match: :first

    assert_text "Address was successfully destroyed"
  end
end
