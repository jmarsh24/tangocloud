require "system_helper"

RSpec.describe "Registration", type: :system do
  it "should register a new user" do
    visit root_path
    click_on "Login"
    click_on "Don't have an account?"
    expect(page).to have_content("Already have an account?")
    fill_in "email", with: "admin@example.com"
    fill_in "password", with: "password123"
    fill_in "password_confirmation", with: "password123"
    click_on "Sign up"
    expect(page).not_to have_content("Login")
    expect(last_mail!.link_urls.first).to include(identity_email_verification_url)
    expect(page).to have_content("Thank you for verifying your email address")
  end
end
