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
  end

  def create
    if (user = User.authenticate_by(email: params[:email], password: params[:password]))
      @session = user.sessions.create!
      cookies.signed.permanent[:session_token] = {value: @session.id, httponly: true}

      redirect_to root_path, notice: "Signed in successfully"
    else
      @session = Session.new
      @session.errors.add(:base, "The email or password is incorrect")
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
