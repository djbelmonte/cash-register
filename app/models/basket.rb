class Basket < ApplicationRecord
  has_many :basket_items, dependent: :destroy
  has_many :products, through: :basket_items

  def total_price
    PromotionService.new(self).get_total_with_promo_applied
  end
end
