class AdminConstraint
  def matches?(request)
    if session = Session.find_by_id(request.cookie_jar.signed[:session_token])
      session.user.admin?
    else
      false
    end
  end
end
