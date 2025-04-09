class UsersController < ApplicationController
  before_action :authenticate_user!

  def profile
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to edit_profile_path, notice: "Address updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_shipping
    @user = current_user
  
    if @user.update(user_params)
      redirect_to profile_path, notice: "Shipping info updated!"
    else
      render :profile, alert: "Could not update shipping info."
    end
  end

  private

  def user_params
    params.require(:user).permit(:province_id, :address, :city, :postal_code)
  end
end
