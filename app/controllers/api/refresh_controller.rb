module Api
  class RefreshController < BaseController
    before_action :authorize_refresh_request!

    # @route POST /api/refresh (api_refresh)
    def create
      session = JWTSessions::Session.new(payload:)
      render json: session.refresh(found_token)
    end
  end
end
