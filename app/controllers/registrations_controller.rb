class RegistrationsController < ApplicationController
  include RemoteModal
  allowed_remote_modal_actions :new, :edit

  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized, :verify_policy_scoped

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session_record = @user.sessions.create!
      cookies.signed.permanent[:session_token] = {value: session_record.id, httponly: true}

      send_email_verification
      redirect_to root_path, notice: "Welcome! You have signed up successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = Current.user
  end

  def update
    @user = Current.user

    if @user.update(user_params)
      redirect_to edit_registration_path(@user), notice: "Your profile has been updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation, :avatar)
  end

  def send_email_verification
    UserMailer.with(user: @user).email_verification.deliver_later
  end
end
