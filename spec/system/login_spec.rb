require "system_helper"

RSpec.describe "Login", type: :system do
  it "should log a user in" do
    create(:user, email: "user@example.com", password: "password123")

    visit root_path
    click_on "Login"
    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "password123"
    click_on "Sign in to account"

    expect(page).not_to have_content("Login")
  end
end
