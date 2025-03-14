require "application_system_test_case"

class MerchantsTest < ApplicationSystemTestCase
  setup do
    @merchant = merchants(:one)
  end

  test "visiting the index" do
    visit merchants_url
    assert_selector "h1", text: "Merchants"
  end

  test "should create merchant" do
    visit merchants_url
    click_on "New merchant"

    check "Active" if @merchant.active
    fill_in "Description", with: @merchant.description
    fill_in "Location", with: @merchant.location
    fill_in "Logo", with: @merchant.logo
    fill_in "Name", with: @merchant.name
    fill_in "Phone", with: @merchant.phone
    fill_in "User", with: @merchant.user_id
    check "Verified" if @merchant.verified
    click_on "Create Merchant"

    assert_text "Merchant was successfully created"
    click_on "Back"
  end

  test "should update Merchant" do
    visit merchant_url(@merchant)
    click_on "Edit this merchant", match: :first

    check "Active" if @merchant.active
    fill_in "Description", with: @merchant.description
    fill_in "Location", with: @merchant.location
    fill_in "Logo", with: @merchant.logo
    fill_in "Name", with: @merchant.name
    fill_in "Phone", with: @merchant.phone
    fill_in "User", with: @merchant.user_id
    check "Verified" if @merchant.verified
    click_on "Update Merchant"

    assert_text "Merchant was successfully updated"
    click_on "Back"
  end

  test "should destroy Merchant" do
    visit merchant_url(@merchant)
    click_on "Destroy this merchant", match: :first

    assert_text "Merchant was successfully destroyed"
  end
end
