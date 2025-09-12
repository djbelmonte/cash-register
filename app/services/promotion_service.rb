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

    items.each_with_index do |item, index|
      if index.odd? # take 1
        item.update_attribute(:promotional_price, "0.00".to_d)
      else
        item.update_attribute(:promotional_price, product.price)
      end
    end
    
    items.map(&:promotional_price).sum
  end

  def fixed_discount_promo_price
    items = basket.basket_items.joins(:product).where(products: { product_code: "SR1" })
    item_count = items.count
    return 0 if item_count == 0
    product = items.first.product

    if item_count >= 3
      items.update_all(promotional_price: 4.50.to_d)
    else
      items.update_all(promotional_price: product.price)
    end

    items.map(&:promotional_price).sum
  end

  def percent_discount_promo_price
    items = basket.basket_items.joins(:product).where(products: { product_code: "CF1" })
    item_count = items.count
    return 0 if item_count == 0
    product = items.first.product

    if item_count >= 3
      promotional_price = (product.price * (2.to_d / 3.to_d)).round(4)
      items.update_all(promotional_price: promotional_price)
    else
      items.update_all(promotional_price: product.price)
    end

    items.map(&:promotional_price).sum.round(2)
  end
end