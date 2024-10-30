class Identity::PasswordResetsController < ApplicationController
  include RemoteModal
  allowed_remote_modal_actions :new, :edit
  force_frame_response only: %i[new]

  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized, :verify_policy_scoped

  rate_limit to: 10, within: 1.hour, only: :create, with: -> { redirect_to root_path, alert: "Try again later" }
  before_action :set_user, only: %i[edit update]

  def new
  end

  def edit
  end

  def create
    @user = User.find_by(email: params[:email], verified: true)
    if @user.present?
      send_password_reset_email
      redirect_to sign_in_path, notice: "Check your email for reset instructions"
    else
      redirect_to new_identity_email_verification_path(email: params[:email])
    end
  end

  def update
    if @user.update(user_params)
      flash[:modal_notice] = "Your password was reset successfully. Please sign in"
      redirect_to sign_in_path, notice: "Your password was reset successfully. Please sign in"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by_token_for!(:password_reset, params[:sid])
  rescue
    redirect_to new_identity_password_reset_path, alert: "That password reset link is invalid"
  end

  def user_params
    params.permit(:password, :password_confirmation)
  end

  def send_password_reset_email
    UserMailer.with(user: @user).password_reset.deliver_later
  end
end
