class AuthToken
  def self.key
    Config.jwt_secret || "test_secret_key"
  end

  def self.token(user)
    payload = {user_id: user.id}
    JWT.encode(payload, key)
  end

  def self.verify(token)
    result = JWT.decode(token, key)[0]
    User.find_by(id: result["user_id"])
  rescue JWT::VerificationError, JWT::DecodeError
    nil
  end
end
