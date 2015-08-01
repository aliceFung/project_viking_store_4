class Admin::OrdersController < AdminController

  def index
    if params[:user_id]
      if User.exists?(params[:user_id])
        @user = User.find(params[:user_id])
        @orders = @user.orders.limit(100)
      else
        flash[:error] = "No user with this ID found."
        redirect_to admin_orders_path
      end
    else
      @orders = Order.all.limit(100)
    end
    render :layout => "admin_layout"
  end

  def new
    @order = Order.new
    @user = User.find(params[:user_id])
    render :layout => "admin_layout"
  end

  def create
    @order = Order.new(whitelisted_order_params)
    @user = User.find(params[:order][:user_id])
    @cart_id=@user.orders.where("checkout_date IS NULL")
    if @cart_id.first
      @order = @cart_id.first
      flash[:error]="Cart already exists, you can only have one cart"
      redirect_to edit_admin_order_path(@order)
    else
        if @order.save
          flash[:success] = "New order created."
          redirect_to edit_order_path(@order)
        else
          flash.now[:error] = @order.errors.full_messages.first
          render :new
        end
    end
    render :layout => "admin_layout"
  end

  def show
    @order = Order.find(params[:id])
    @user=User.find(@order.user_id)
    render :layout => "admin_layout"
  end

  def edit
    @order = Order.find(params[:id])
    @user = User.find(@order.user_id)
    @status_changed=params[:status]
    render :layout => "admin_layout"
  end

  def update
    @order = Order.find(params[:id])
    @user = User.find(@order.user_id)
    if params[:order][:status]
      @order.update_status(params[:order][:status])
      flash[:success] = "Order status changed!"
      redirect_to admin_order_path(@order)
    else
      flash.now[:error] = "Aww. Your order status was not updated."
      render :edit, :layout => "admin_layout"
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    @order = Order.find(params[:id])
    if @order.destroy
      flash[:success] = "Order successfully deleted."
      redirect_to admin_orders_path
    else
      flash[:error] = @order.errors.full_messages.first
      redirect_to session.delete(:return_to)
    end
    render :layout => "admin_layout"
  end

  def update_quantity
    @order = Order.find(params[:id])
    @user = User.find(@order.user_id)
    if params[:order][:ordercontents]
      @order.bulk_update_contents(params)
      flash[:success] = "Order successfully modified."
      redirect_to admin_order_path(@order)
    else
      flash.now[:error] = "Aww. Your order was not updated."
      render :edit, :layout => "admin_layout"
    end
  end

  def add_products
    @order = Order.find(params[:id])
    @user = User.find(@order.user_id)
    if params[:products] && @order.add_products(params)
      flash[:success] = "Products successfully added to order."
      redirect_to admin_order_path(@order)
    else
      flash.now[:error] = "Aww. Your order was not updated."
      render :edit, :layout => "admin_layout"
    end
  end

  private

  def whitelisted_order_params
    params.require(:order).permit(:checkout_date,
                                    :user_id,
                                    :shipping_id,
                                    :billing_id,
                                    :ordercontents=>[]
                                   )
  end
end
