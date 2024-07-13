module Mutations
  module Users
    class Refresh < Mutations::BaseMutation
      Session = Data.define(:access, :access_expires_at, :refresh, :refresh_expires_at).freeze

      include Dry::Monads[:result]
      type Types::RefreshResultType, null: false

      argument :refresh_token, String, required: true

      def resolve(refresh_token:)
        session = JWTSessions::Session.new(refresh_by_access_allowed: true)
        session.refresh(refresh_token)
        refreshed_session = session.login

        session = Session.new(
          access: refreshed_session[:access],
          access_expires_at: refreshed_session[:access_expires_at],
          refresh: refreshed_session[:refresh],
          refresh_expires_at: refreshed_session[:refresh_expires_at]
        )

        Success(session)
      rescue JWTSessions::Errors::Unauthorized
        Failure(message: "Invalid refresh token")
      end
    end
  end
end
