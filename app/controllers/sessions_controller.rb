class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      sign_in user
      flash[:success] = "Thanks for signing in, #{user.full_name}!"
      if session[:return_to]
        redirect_to session.delete(:return_to)
      else
        redirect_to root_path
      end
    else
      flash[:error] = "We couldn't sign you in due to error!"
      render :new
    end
  end

  def destroy
    user = current_user
    if sign_out
      flash[:success] = "You have signed out!"
      redirect_to root_path
    else
      flash[:error] = "Angry robots have prevented you from signing out.  You're stuck here forever."
      redirect_to root_path
    end
  end
end
