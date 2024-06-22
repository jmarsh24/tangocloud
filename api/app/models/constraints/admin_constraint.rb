module Constraints
  class AdminConstraint
    def matches?(request)
      session_token = request.cookie_jar.signed[:session_token]
      return false unless session_token

      session = Session.find_by_id(session_token)
      return false unless session

      Current.session = session
      Current.user = session.user

      session.user.admin?
    end
  end
end
