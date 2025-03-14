require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  setup do
    @order = orders(:one)
  end

  test "visiting the index" do
    visit orders_url
    assert_selector "h1", text: "Orders"
  end

  test "should create order" do
    visit orders_url
    click_on "New order"

    fill_in "Address", with: @order.address
    fill_in "Merchant", with: @order.merchant_id
    fill_in "Payment status", with: @order.payment_status
    fill_in "Reference", with: @order.reference
    fill_in "Status", with: @order.status
    fill_in "Total amount", with: @order.total_amount
    fill_in "User", with: @order.user_id
    click_on "Create Order"

    assert_text "Order was successfully created"
    click_on "Back"
  end

  test "should update Order" do
    visit order_url(@order)
    click_on "Edit this order", match: :first

    fill_in "Address", with: @order.address
    fill_in "Merchant", with: @order.merchant_id
    fill_in "Payment status", with: @order.payment_status
    fill_in "Reference", with: @order.reference
    fill_in "Status", with: @order.status
    fill_in "Total amount", with: @order.total_amount
    fill_in "User", with: @order.user_id
    click_on "Update Order"

    assert_text "Order was successfully updated"
    click_on "Back"
  end

  test "should destroy Order" do
    visit order_url(@order)
    click_on "Destroy this order", match: :first

    assert_text "Order was successfully destroyed"
  end
end
