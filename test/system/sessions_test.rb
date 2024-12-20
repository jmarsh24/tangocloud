require "application_system_test_case"

class SessionsTest < ApplicationSystemTestCase
  setup do
    @user = users(:normal)
  end

  test "signing in" do
    visit root_path

    click_on "Login"
    fill_in "Email", with: "user@tangocloud.app"
    fill_in "Password", with: "Secret1*3*5*"
    click_on "Sign in to account"

    assert_no_link "Login"
  end

  test "signing out" do
    sign_in_as @user

    find("#user_navbar_toggle").click
    click_on "Sign Out"

    assert_text "You have signed out successfully"
  end
end
