class AuthController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_after_action :verify_authorized

  def facebook_data_deletion
    binding.irb
    user = User.find_by(provider: "facebook", uid: params[:id])

    if user
      user.destroy
      render json: { success: true, message: "User data deleted." }
    else
      render json: { success: false, message: "User not found." }, status: 404
    end
  end
end
