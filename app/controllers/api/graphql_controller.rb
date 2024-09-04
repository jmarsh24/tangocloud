module Api
  class GraphQLController < ActionController::API
    include JWTSessions::RailsAuthorization

    before_action :authorize_admin!, unless: -> { introspection_query? && Rails.env.development? }

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

    def current_user
      # In development, bypass JWT and use Devise for easier testing
      if Rails.env.development?
        devise_user = warden.authenticate(scope: :user)
        return devise_user if devise_user
      end

      # Fall back to JWT session
      return unless payload.present?

      User.find(payload["user_id"])
    end

    # Authorize only admin users
    def authorize_admin!
      unless current_user&.admin?
        render json: {error: "Not authorized"}, status: :unauthorized
      end
    end

    # Check if the current query is an introspection query
    def introspection_query?
      query = params[:query]
      query.include?("__schema") || query.include?("__type")
    end
  end
end
