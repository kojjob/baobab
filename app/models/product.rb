class Product < ApplicationRecord
  belongs_to :merchant
  belongs_to :category
end
