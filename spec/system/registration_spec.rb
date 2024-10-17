require "system_helper"

RSpec.describe "Registration", type: :system do
  it "should register a new user" do
    visit root_path
    click_on "Login"
    click_on "Don't have an account?"

    expect(page).to have_content("Already have an account?")

    fill_in "email", with: "user@example.com"
    fill_in "password", with: "password123"
    fill_in "password_confirmation", with: "password123"
    click_on "Sign up"

    expect(page).not_to have_content("Login")
    expect(last_mail!.link_urls.first).to include(identity_email_verification_url)

    verification_link = last_mail!.link_urls.first

    uri = URI.parse(verification_link)

    path_with_query = "#{uri.path}?#{uri.query}"

    visit path_with_query

    expect(page).to have_content("Thank you for verifying your email address")
    user = User.find_by(email: "user@example.com")
    expect(user.verified).to be_truthy
  end

  it "should reset a password" do
    user = create(:user, email: "user@example.com")
    visit root_path
    click_on "Login"
    click_on "Forgot your password?"

    expect(page).to have_content("Forgot your password?")

    fill_in "email", with: "user@example.com"
    click_on "Send password reset email"

    expect(page).to have_content("Check your email for reset instructions.")
    expect(last_mail!.link_urls.first).to include(identity_password_reset_url)

    reset_link = last_mail!.link_urls.first

    uri = URI.parse(reset_link)

    path_with_query = "#{uri.path}?#{uri.query}"

    visit path_with_query

    fill_in "password", with: "newpassword123"
    fill_in "password_confirmation", with: "newpassword123"
    click_on "Save changes"
    expect(page).to have_content("Login")
    expect(user.reload.authenticate("newpassword123")).to be_truthy
  end
end
