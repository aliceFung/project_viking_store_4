class Admin::AddressesController < AdminController


  def index
    if params[:user_id]
      if User.exists?(params[:user_id])
        @addresses = User.find(params[:user_id]).addresses
        @user = User.find(params[:user_id])
      else
        flash[:error] = "No user with this ID found."
        redirect_to admin_addresses_path
      end
    else
      @addresses = Address.all
    end
    render :layout => "admin_layout"
  end

  def new
    @address = Address.new
    @user = User.find(params[:user_id])
    render :layout => "admin_layout"
  end

  def create
    @address = Address.new(white_listed_address_params)
    @address.city_id = check_city(params[:address][:city])
    # @user = User.find(@address.user_id)
    if @address.save
      flash[:success] = "New address created."
      redirect_to admin_addresses_path
    else
      flash.now[:error] = @address.errors.full_messages.first
      render :new, :layout => "admin_layout"
    end
  end

  def show
    @address = Address.find(params[:id])
    render :layout => "admin_layout"
  end

  def edit
    @address = Address.find(params[:id])

    @user = User.find(@address.user_id)
    render :layout => "admin_layout"
  end

  def update
    @address = Address.find(params[:id])
    @address.city_id = check_city(params[:address][:city])
    if @address.update(white_listed_address_params)
      flash[:success] = "Address successfully modified."
      redirect_to admin_addresses_path
    else
      flash.now[:error] = @address.errors.full_messages.first
      render :edit, :layout => "admin_layout"
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    @address = Address.find(params[:id])
    if @address.destroy
      flash[:success] = "address successfully deleted."
      redirect_to admin_addresses_path
    else
      flash[:error] = @address.errors.full_messages.first
      redirect_to session.delete(:return_to)
    end
  end

  private

  def white_listed_address_params
    params.require(:address).permit(:street_address,
                                    :secondary_address,
                                    :zip_code,
                                    :city_id,
                                    :state_id,
                                    :user_id)
  end

  def check_city(name)
    city_name = City.check_city_name(name)
    if city_name
      city_name.id
    else
      new_city = City.create({:name => name})
      new_city.id
    end
  end

end
