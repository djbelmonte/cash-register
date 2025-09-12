class PromotionService
  def initialize(basket)
    @basket = basket
  end

  attr_accessor :basket

  def get_total_with_promo_applied
    [buy_1_get_1_promo_price.to_d, fixed_discount_promo_price.to_d, percent_discount_promo_price.to_d].sum
  end

  private

  def buy_1_get_1_promo_price
    items = basket.basket_items.joins(:product).where(products: { product_code: "GR1" })
    item_count = items.count
    return 0 if item_count == 0
    product = items.first.product

    count = ((item_count / 2) + (item_count % 2))
    (count.to_d * product.price.to_d).round(2)
  end

  def fixed_discount_promo_price
    items = basket.basket_items.joins(:product).where(products: { product_code: "SR1" })
    item_count = items.count
    return 0 if item_count == 0
    product = items.first.product
    product_discounted_price = 4.50.to_d

    total = if item_count >= 3
      item_count.to_d * product_discounted_price
    else
      item_count.to_d * product.price
    end

    total.round(2)
  end

  def percent_discount_promo_price
    items = basket.basket_items.joins(:product).where(products: { product_code: "CF1" })
    item_count = items.count
    return 0 if item_count == 0
    product = items.first.product

    total = if item_count >= 3
      (item_count * product.price * (2.to_d / 3.to_d)).round(2)
    else
      (item_count * product.price).round(2)
    end

    total.round(2)
  end
end