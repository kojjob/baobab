class AddDatabaseConstraints < ActiveRecord::Migration[8.0]
  def change
    # Ensure positive values for quantities and prices
    add_check_constraint :products, "price >= 0", name: "check_product_price_positive"
    add_check_constraint :products, "stock_quantity >= 0", name: "check_product_stock_positive"

    # Ensure ratings are within valid range
    add_check_constraint :reviews, "rating >= 1 AND rating <= 5", name: "check_review_rating_range"

    # Email format validation
    add_check_constraint :users, "email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'", name: "check_email_format"
  end
end
