class AuthController < ApplicationController
  skip_before_action :authenticate_user!_user!, only: [:facebook_data_deletion]
  skip_after_action :verify_authorized, only: [:facebook_data_deletion]

  def facebook_data_deletion
    user = User.find_by(provider: "facebook", uid: params[:id])

    if user
      user.destroy!
      render json: { success: true, message: "User data deleted." }
    else
      render json: { success: false, message: "User not found." }, status: 404
    end
  end
end
