class CartsController < ApplicationController

  def shopping_cart

    @order = @current_user.shopping_cart if signed_in_user?
    # else
    #   @order = Order.new

    #   session[:cart].each do |item_id, quan|
    #     @order.order_contents.build(product_id: item_id.to_i, quantity: quan)
    #   end
    # end
  end


end
