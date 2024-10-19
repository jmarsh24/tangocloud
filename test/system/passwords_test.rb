require "application_system_test_case"

class PasswordsTest < ApplicationSystemTestCase
  setup do
    @user = users(:normal)
  end

  test "updating the password" do
    sign_in_as(@user)

    find("#user_navbar_toggle").click
    find("a", text: "Edit").click

    fill_in "username", with: "user"
    fill_in "password", with: "Secret6*4*2*"
    fill_in "Confirm Password", with: "Secret6*4*2*"
    click_on "Update"

    assert_text "Your profile has been updated successfully."
  end
end
