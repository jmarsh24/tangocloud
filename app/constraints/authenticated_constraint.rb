# frozen_string_literal: true

class AuthenticatedConstraint
  def user
    return unless ActionAuth::Current.user
    ActionAuth::Current.user.becomes(User)
  end
end
