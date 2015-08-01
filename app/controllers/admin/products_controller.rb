class Admin::ProductsController < AdminController

  def index
    @products = Product.all
    render :layout => "admin_layout"
  end

  def new
    @product = Product.new
    render :layout => "admin_layout"
  end

  def create
    @product = Product.new(white_listed_product_params)
    @product.sku = (Faker::Code.ean).to_i
    if @product.save
      flash[:success] = "New product created."
      redirect_to admin_products_path
    else
      flash.now[:error] = @product.errors.full_messages.first
      render :new, :layout => "admin_layout"
    end
  end

  def show
    @product = Product.find(params[:id])
    render :layout => "admin_layout"
  end

  def edit
    @product = Product.find(params[:id])
    render :layout => "admin_layout"
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(white_listed_product_params)
      flash[:success] = "Product successfully modified."
      redirect_to admin_products_path
    else
      flash.now[:error] = @product.errors.full_messages.first
      render :edit, :layout => "admin_layout"
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    @product = Product.find(params[:id])
    if @product.destroy
      flash[:success] = "Product successfully deleted."
      redirect_to admin_products_path
    else
      flash[:error] = @product.errors.full_messages.first
      redirect_to session.delete(:return_to)
    end
  end

  private

  def white_listed_product_params
    params.require(:product).permit(:name, :price, :description, :category_id, :sku)
  end

end
