class Product < ApplicationRecord
  PROMOTIONS = {
    :buy_1_take_1 => ["GR1"],
    :fixed_discount => ["SR1"],
    :percent_discount => ["CF1"],
  }.freeze
end
