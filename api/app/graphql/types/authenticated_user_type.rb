module Types
  class AuthenticatedUserType < BaseObject
    Session = Data.define(:access, :access_expires_at, :refresh, :refresh_expires_at).freeze

    field :id, ID, null: true
    field :email, String, null: true
    field :username, String, null: true
    field :session, Types::SessionType, null: false

    def session
      payload = {user_id: object.id}
      session = JWTSessions::Session.new(payload:, refresh_by_access_allowed: true)
      tokens = session.login

      Session.new(
        access: tokens[:access],
        access_expires_at: Time.at(tokens[:access_expires_at]),
        refresh: tokens[:refresh],
        refresh_expires_at: Time.at(tokens[:refresh_expires_at])
      )
    end
  end
end
