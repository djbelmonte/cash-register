class ProductsController < ApplicationController
  def index
    @products = Product.all
    @basket = Basket.first_or_create!
    @basket_total = @basket.total_price
  end
end
