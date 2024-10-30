class RegistrationsController < ApplicationController
  include RemoteModal
  allowed_remote_modal_actions :new, :edit
  force_frame_response :new, :edit

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

      respond_to do |format|
        format.html do
          redirect_to root_path, notice: "Welcome! You have signed up successfully"
        end
        format.turbo_stream do
          render turbo_stream: turbo_stream.redirect_to(root_path)
        end
      end
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
      flash[:modal_notice] = "Your profile has been updated successfully."
      redirect_to edit_registration_path(@user)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Current.user.destroy
    flash[:notice] = "Your account has been deleted successfully."
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.redirect_to(root_path)
      end
    end
  end

  private

  def user_params
    params.permit(:email, :username, :password, :password_confirmation, :avatar)
  end

  def send_email_verification
    UserMailer.with(user: @user).email_verification.deliver_later
  end
end
