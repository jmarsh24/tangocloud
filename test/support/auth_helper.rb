module AuthHelper
  def sign_in_as(user)
    post(sign_in_url, params: {email: user.email, password: "Secret1*3*5*"})
    user
  end
end
