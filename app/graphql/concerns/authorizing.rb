module Authorizing
  extend ActiveSupport::Concern

  included do
    def authorize(record, query)
      policy = policy(record)

      unless policy.public_send(query)
        raise Pundit::NotAuthorizedError, query:, record:, policy:
      end

      record
    end

    private

    def policy(record)
      Pundit.policy!(current_user, record)
    end

    def current_user
      current_user = context[:current_user]

      raise JWTSessions::Errors::Unauthorized, "Not authorized" unless current_user

      current_user
    end
  end
end
