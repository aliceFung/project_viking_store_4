class Admin::OrderContentsController < AdminController

  # def edit
  #   @order= Order.find(params[:order_id])
  #   @order_contents = OrderContents.where("order_id = ?", @order.id)
  # end
  def order_list
    @order= Order.find(params[:order_id])
    @order_contents = OrderContents.where("order_id = ?", @order.id)
  end

  def update
    @order= Order.find(params[:order_id])
    @order_contents = OrderContents.where("order_id = ?", @order.id)
    @order.order_contents.each do |oc|
      oc.update(whitelisted_params)
    end
    redirect_to admin_order_path(@order)
  end


    # [order][order_content_id][product_id: quantity]

    # if params[:order][:status]=="true"
    #   @order.checkout_date=Time.now
    # else
    #   @order.checkout_date=nil
    # end


    # if @order.update(whitelisted_order_params)

    #   flash[:success] = "order successfully modified."
    #   redirect_to edit_order_contents_path
    # else
    #   flash.now[:error] = @order.errors.full_messages.first
    #   render :edit
    # end

  end


  private

  def whitelisted_params
    params.require(:order_contents).permit(:order_id, :id => [])
  end
end
