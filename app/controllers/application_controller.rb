# class ApplicationController < ActionController::Base
#   # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
#   allow_browser versions: :modern

#   # before_action :configure_permitted_parameters, if: :devise_controller?

#   before_action :authenticate_user!

#   protected

#   def configure_permitted_parameters
#     devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation, :address, :province])
#     devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :password, :password_confirmation, :current_password, :address, :province])
#   end

#   # Only authenticate admin users for ActiveAdmin pages
#   # def authenticate_admin_user!
#   #   if current_user.nil? || !current_user.admin?
#   #     redirect_to root_path, alert: "Access Denied. You are not an admin."
#   #   end
#   # end

# end


class ApplicationController < ActionController::Base
  before_action :authenticate_user! # Devise forces login by default for all actions

  # Allow guest access to specific controllers
  skip_before_action :authenticate_user!, if: -> { controller_name == 'products' || controller_name == 'orders' }
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation, :address, :city, :province, :postal_code])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :password, :password_confirmation, :current_password, :address, :city, :province, :postal_code])
  end
end
