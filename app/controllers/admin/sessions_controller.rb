# class Admin::SessionsController < Devise::SessionsController
#     before_action :check_admin, only: [:create]
  
#     private
  
#     def check_admin
#       user = User.find_by(email: params[:user][:email])
#       if user && !user.admin?
#         flash[:alert] = "Access Denied. You are not an admin."
#         redirect_to new_user_session_path
#       end
#     end
#   end
  