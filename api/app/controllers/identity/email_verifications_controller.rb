class Identity::EmailVerificationsController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  skip_after_action :verify_authorized

  before_action :set_user, only: :show

  def show
    @user.update! verified: true
    # redirect_to root_path, notice: "Thank you for verifying your email address"
    app_login_url = "tangocloudapp://login?email=#{@user.email}"

    redirect_to app_login_url, allow_other_host: true
  end

  def create
    send_email_verification
    redirect_to root_path, notice: "We sent a verification email to your email address"
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

  def generate_safe_redirect_url(email)
    "tangocloudapp://login?email=#{CGI.escape(email)}"
  end

  def valid_url?(url)
    allowed_hosts = ["tangocloudapp"]
    uri = URI.parse(url)
    allowed_hosts.include?(uri.host)
  rescue URI::InvalidURIError
    false
  end
end
