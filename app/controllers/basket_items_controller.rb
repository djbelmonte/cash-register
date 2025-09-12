class BasketItemsController < ApplicationController
  before_action :set_basket
  
  def create
    product = Product.find(params[:product_id])
    @basket.basket_items.create!(product: product)
    redirect_to root_path

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end

  def destroy
    item = @basket.basket_items.find(params[:id])
    item.destroy
    redirect_to root_path

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end

  private

  def set_basket
    @basket = Basket.first_or_create!
  end
end
