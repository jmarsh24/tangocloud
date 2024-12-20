require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get sign_up_url, headers: {"Turbo-Frame" => "modal"}

    assert_response :success
  end

  test "should sign up" do
    assert_difference("User.count") do
      post sign_up_url, params: {email: "user@tangocloud.com", password: "Secret1*3*5*", password_confirmation: "Secret1*3*5*"}
    end

    assert_redirected_to root_url
  end
end
