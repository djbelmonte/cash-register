class PromotionService
  def initialize(basket)
    @basket = basket
  end

  attr_accessor :basket

  def get_total_with_promo_applied
    Product::PROMOTIONS.map do |promo, product_codes|
      case promo
      when :buy_1_take_1
        buy_1_get_1_promo_price(product_codes)
      when :fixed_discount
        fixed_discount_promo_price(product_codes)
      when :percent_discount
        percent_discount_promo_price(product_codes)
      end
    end.sum
  end

  private

  def buy_1_get_1_promo_price(product_codes)
    items = basket.basket_items.joins(:product)
                               .where(products: { product_code: product_codes })
                               .to_a
                               .group_by { |item| item.product.product_code }.values
    item_count = items.count
    return 0 if item_count == 0
    sum = 0.0.to_d

    items.each do |group|
      group.each_with_index do |item, index|
        if index.odd? # take 1
          item.update_attribute(:promotional_price, 0.00.to_d)
          sum += 0.00.to_d
        else
          item.update_attribute(:promotional_price, item.product.price)
          sum += item.product.price
        end
      end
    end
    
    sum
  end

  def fixed_discount_promo_price(product_codes)
    items = basket.basket_items.joins(:product).where(products: { product_code: product_codes })
    item_count = items.count
    return 0 if item_count == 0

    if item_count >= 3
      items.update_all(promotional_price: 4.50.to_d)
    else
      items.update_all("promotional_price = products.price")
    end

    items.map(&:promotional_price).sum
  end

  def percent_discount_promo_price(product_codes)
    items = basket.basket_items.joins(:product).where(products: { product_code: product_codes })
    item_count = items.count
    return 0 if item_count == 0
    product = items.first.product

    if item_count >= 3
      items.update_all("promotional_price = ROUND(products.price * (2/3), 4)")
    else
      items.update_all("promotional_price = products.price")
    end

    items.map(&:promotional_price).sum.round(2)
  end
end