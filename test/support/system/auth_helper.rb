module AuthHelper
  def sign_in_as(user)
    visit root_path
    click_on "Login"

    fill_in :email, with: user.email
    fill_in :password, with: "Secret1*3*5*"
    click_on "Sign in to account"

    assert_current_path root_url
    user
  end
end
