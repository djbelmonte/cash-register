require "test_helper"

class BasketTest < ActiveSupport::TestCase
  test "total price should be the same as expected" do
    test_data = {
      ["GR1", "SR1", "GR1", "GR1", "CF1"] => 22.45,
      ["GR1", "GR1"] => 3.11,
      ["SR1", "SR1", "GR1", "SR1"] => 16.61, 
      ["GR1", "CF1", "SR1", "CF1", "CF1"] => 30.57
    }
     
    test_data.each do |test_case, expected|
      basket = Basket.new
      test_case.each do |product_code|
        BasketItem.create!(basket: basket, product: Product.find_by_product_code(product_code))
      end

      assert_equal expected, basket.total_price
    end
  end

  test "total price should be the same as expected even with difference order" do
    test_data = {
      ["SR1", "GR1", "GR1", "CF1", "GR1"] => 22.45,
      ["GR1", "GR1"] => 3.11,
      ["GR1", "SR1", "SR1", "SR1"] => 16.61, 
      ["CF1", "CF1", "SR1", "CF1", "GR1"] => 30.57
    }
     
    test_data.each do |test_case, expected|
      basket = Basket.new
      test_case.each do |product_code|
        BasketItem.create!(basket: basket, product: Product.find_by_product_code(product_code))
      end

      assert_equal expected, basket.total_price
    end
  end
end
