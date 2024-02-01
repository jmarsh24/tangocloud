# app/constraints/admin_constraint.rb

class Constraints::AdminConstraint
  def self.matches?(request)
    if (session = Session.find_by(request.cookie_jar.signed[session_token]))
      session.user.admin?
    else
      false
    end
  end
end
