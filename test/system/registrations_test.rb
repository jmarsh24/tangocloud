require "application_system_test_case"

class RegistrationsTest < ApplicationSystemTestCase
  test "signing up" do
    visit root_path

    click_on "Login"
    click_on "Don't have an account?"

    assert_link "Already have an account?"

    fill_in "Email", with: "user@tangocloud.com"
    fill_in "Password", with: "Secret6*4*2*"
    fill_in "Confirm Password", with: "Secret6*4*2*"
    click_on "Sign up"

    assert_no_link "Login"
  end
end
