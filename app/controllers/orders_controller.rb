class OrdersController < ApplicationController

  def shopping_cart
    if signed_in_user?
      @order = @current_user.shopping_cart
    else
      @order = Order.new

      session[:cart].each do |item_id, quan|
        @order.order_contents.build(product_id: item_id.to_i, quantity: quan)
      end
    end
  end

  def update

  end

  def checkout

  end
end
