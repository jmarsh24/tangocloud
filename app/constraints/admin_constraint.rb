# frozen_string_literal: true

class AdminConstraint
  def self.matches?(request)
    user = current_user(request).becomes(User)
    user&.admin?
  end

  def self.current_user(request)
    session_token = request.cookie_jar.signed[:session_token]
    ActionAuth::Session.find_by(id: session_token)&.action_auth_user
  end
end
