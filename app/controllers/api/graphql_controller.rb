module Api
  class GraphQLController < ActionController::API
    include JWTSessions::RailsAuthorization
    before_action :authenticate_user!
    rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

    # @route POST /api/graphql (api_graphql)
    # @route POST /api/graphql (api_graphql)
    def execute
      variables = prepare_variables(params[:variables])
      query = params[:query]
      operation_name = params[:operationName]

      context = {
        current_user:
      }

      result = TangocloudSchema.execute(query, variables:, context:, operation_name:)
      render json: result
    rescue => e
      raise e unless Rails.env.development?
      handle_error_in_development(e)
    end

    private

    # Handle variables in form data, JSON body, or a blank value
    def prepare_variables(variables_param)
      case variables_param
      when String
        if variables_param.present?
          JSON.parse(variables_param) || {}
        else
          {}
        end
      when Hash
        variables_param
      when ActionController::Parameters
        variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
      when nil
        {}
      else
        raise ArgumentError, "Unexpected parameter: #{variables_param}"
      end
    end

    def handle_error_in_development(e)
      logger.error e.message
      logger.error e.backtrace.join("\n")

      render json: {errors: [{message: e.message, backtrace: e.backtrace}], data: {}}, status: :internal_server_error
    end

    def not_authorized
      message = "Not authorized"
      if Rails.env.development?
        message += ". Please login via the web interface to authenticate."
      end
      render json: {error: message}, status: :unauthorized
    end

    def authenticate_user!
      return if Rails.env.development? && introspection_query?
      return if current_user.present?

      raise JWTSessions::Errors::Unauthorized
    end

    def current_user
      # if the user is logged in via the web application in development
      # we bypass the jwt token authentication and return a user from the cookies
      if Rails.env.development?
        devise_user = warden.authenticate(scope: :user)
        return devise_user if devise_user
      end

      # Fall back to JWT session
      return unless payload.present?

      @current_user ||= User.find(payload["user_id"])
    end

    def introspection_query?
      params[:query].present? && params[:query].include?("__schema")
    end
  end
end
