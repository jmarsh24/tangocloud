class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Authenticable

  after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  skip_after_action :verify_authorized, if: :mission_control_controller?

  private

  def user_not_authorized(exception)
    flash[:alert] = I18n.t "pundit.not_authorized"
    redirect_back(fallback_location: login_path)
  end

  def mission_control_controller?
    # Pundit::AuthorizationNotPerformedError in MissionControl::Jobs::WorkersController#index
    # Pundit::AuthorizationNotPerformedError in MissionControl::Jobs::Queues::PausesController#create
    # Pundit::AuthorizationNotPerformedError in MissionControl::Jobs::RetriesController#create
    is_a?(::MissionControl::Jobs::QueuesController) ||
      is_a?(::MissionControl::Jobs::JobsController) ||
      is_a?(::MissionControl::Jobs::WorkersController) ||
      is_a?(::MissionControl::Jobs::Queues::PausesController) ||
      is_a?(::MissionControl::Jobs::RetriesController)
  end
end
