class PasswordsController < ApplicationController
  include RemoteModal
  allowed_remote_modal_actions :edit
  before_action :set_user

  skip_after_action :verify_authorized, :verify_policy_scoped

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to root_path, notice: "Your password has been changed"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = Current.user
  end

  def user_params
    params.permit(:password, :password_confirmation, :password_challenge).with_defaults(password_challenge: "")
  end
end