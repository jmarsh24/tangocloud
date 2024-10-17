require "system_helper"

RSpec.describe "Login", type: :system do
  it "should log a user in" do
    create(:user, email: "user@example.com", password: "password123")

    visit root_path
    click_on "Login"
    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "password123"
    click_on "Sign in to account"
    expect(page).to have_content("Welcome! You have signed in successfully")
  end
end
