# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

products = [
  { product_code: "GR1", name: "Green Tea", price: 3.11 },
  { product_code: "SR1", name: "Strawberries", price: 5.00 },
  { product_code: "CF1", name: "Coffee", price: 11.23 },
]

products.each do |p|
  Product.find_or_create_by!(product_code: p[:product_code]) do |product|
    product.price = p[:price]
    product.name = p[:name]
  end
end
