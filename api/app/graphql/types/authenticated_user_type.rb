module Types
  class AuthenticatedUserType < BaseObject
    field :id, ID, null: true
    field :email, String, null: true
    field :username, String, null: true
    field :access, String, null: true
    field :access_expires_at, GraphQL::Types::ISO8601DateTime, null: true
    field :refresh, String, null: true
    field :refresh_expires_at, GraphQL::Types::ISO8601DateTime, null: true

    def access
      tokens[:access]
    end

    def access_expires_at
      Time.at(tokens[:access_expires_at])
    end

    def refresh
      tokens[:refresh]
    end

    def refresh_expires_at
      Time.at(tokens[:refresh_expires_at])
    end

    private

    def tokens
      @tokens ||= begin
        payload = {user_id: object.id}
        session = JWTSessions::Session.new(payload:, refresh_by_access_allowed: true)
        session.login
      end
    end
  end
end
