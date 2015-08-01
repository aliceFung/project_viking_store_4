class UsersController < ApplicationController

  def new
    @user = User.new
    @user.addresses.build
    @user.addresses.build
  end

  def create
    @user = User.new(whitelisted_params)
    if @user.save
      flash[:success] = "You have successfully signed up!"
      redirect_to products_path
    else
      flash[:error] = @user.errors.full_messages.first
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update  #need to confirm user matched form user_id?
    @user = current_user
    if @user.update(whitelisted_params)
      flash[:success] = "User Updated"
      redirect_to user_path
    else
      flash[:error] = @user.errors.full_messages.first
      render :edit
    end
  end

  def destroy #need to confirm user matched form user_id?
    @user = current_user
    if @user.destroy
      flash[:success] = "We're sorry to see you go."
      redirect_to products_path
    else
      flash[:error] = "We couldn't delete your account. You're stuck with us forever! Muahahaha!"
      render :edit
    end
  end

  private

  def whitelisted_params
    params.require(:user).permit(:email, :confirm_email, :password, :confirm_password, :id, :first_name, :last_name, :default_shipping_id, :default_billing_id,
        { :addresses_attributes => [:street_address, :city_id, :state_id, :zip_code, :_destroy]})

  end
end
