class AddPromotionalPriceToBasketItem < ActiveRecord::Migration[8.0]
  def change
    add_column :basket_items, :promotional_price, :decimal, precision: 10, scale: 4
  end
end
