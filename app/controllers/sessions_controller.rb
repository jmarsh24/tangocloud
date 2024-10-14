class SessionsController < ApplicationController
  include RemoteModal
  allowed_remote_modal_actions :new, :index

  skip_before_action :authenticate_user!, only: %i[new create]
  skip_after_action :verify_authorized, :verify_policy_scoped

  before_action :set_session, only: :destroy

  def index
    @sessions = Current.user.sessions.order(created_at: :desc)
  end

  def new
    @minimum_password_length = User::MINIMUM_PASSWORD_LENGTH
  end

  def create
    if (user = User.authenticate_by(email: params[:email], password: params[:password]))
      @session = user.sessions.create!
      cookies.signed.permanent[:session_token] = {value: @session.id, httponly: true}

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.redirect_to(root_path)
        end
      end
    else
      @session = Session.new
      @session.errors.add(:base, "The email or password is incorrect")
      @email_hint = params[:email]
      @minimum_password_length = User::MINIMUM_PASSWORD_LENGTH
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @session.destroy
    redirect_to(sessions_path)
  end

  private

  def set_session
    @session = Current.user.sessions.find(params[:id])
  end
end
