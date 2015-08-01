class OrdersController < ApplicationController

  # def shopping_cart

  #   @order = @current_user.shopping_cart if signed_in_user?
  #   # else
  #   #   @order = Order.new

  #   #   session[:cart].each do |item_id, quan|
  #   #     @order.order_contents.build(product_id: item_id.to_i, quantity: quan)
  #   #   end
  #   # end
  # end

  def update

  end

  def checkout
    session[:return_to] ||= request.referer
    if signed_in_user?
      flash.now[:success]= "You are ready to checkout your order."
    else
      flash[:error] = "Please sign in before checking out."
      redirect_to new_session_path
    end
  end
end
