class Identity::EmailVerificationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :show, :create]
  skip_after_action :verify_authorized, :verify_policy_scoped

  before_action :set_user, only: :show

  def new
    @email = params[:email]
  end

  def show
    @user.update! verified: true
    redirect_to root_path, notice: "Thank you for verifying your email address"
  end

  def create
    if params[:email]
      resend_email_verification
    end

    send_email_verification
    flash[:modal_notice] = "We sent a verification email to your email address"

    respond_to do |format|
      format.html do
        redirect_to(root_path, notice: "We sent a verification email to your email address")
      end
      format.turbo_stream do
        render turbo_stream: turbo_stream.redirect_to(root_path)
      end
    end
  end

  private

  def set_user
    @user = User.find_by_token_for!(:email_verification, params[:sid])
  rescue
    redirect_to edit_identity_email_path, alert: "That email verification link is invalid"
  end

  def send_email_verification
    UserMailer.with(user: Current.user).email_verification.deliver_later
  end

  def resend_email_verification
    UserMailer.with(user: User.find_by(email: params[:email])).email_verification.deliver_later
  end
end
