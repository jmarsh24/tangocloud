module Api
  class GraphQLController < ActionController::API
    include JWTSessions::RailsAuthorization
    rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

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
      render json: {error: "Not authorized"}, status: :unauthorized
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
  end
end
