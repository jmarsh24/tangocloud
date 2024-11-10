require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:normal)
  end

  test "should get index" do
    sign_in_as @user

    get sessions_url
    assert_response :success
  end

  test "should get new" do
    get sign_in_url, headers: {"Turbo-Frame" => "modal"}

    assert_response :success
  end

  test "should sign in" do
    @user.update!(role: :tester)

    post sign_in_url, params: {email: @user.email, password: "Secret1*3*5*"}

    assert_redirected_to root_url

    follow_redirect!

    assert_redirected_to music_library_url

    follow_redirect!

    assert_response :success
  end

  test "should not sign in with wrong credentials" do
    post sign_in_url, params: {email: @user.email, password: "SecretWrong1*3"}
    assert_response :unprocessable_entity
    assert_includes assigns(:session).errors[:base], "The email or password is incorrect"

    get edit_identity_email_url
    assert_redirected_to sign_in_url
  end

  test "should sign out" do
    sign_in_as @user

    delete session_url(@user.sessions.last)
    assert_redirected_to root_url
  end
end
