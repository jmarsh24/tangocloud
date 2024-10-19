require "application_system_test_case"

class OrchestrasTest < ApplicationSystemTestCase
  test "visiting the index" do
    sign_in_as users(:admin)

    visit orchestras_url

    assert_selector "h1", text: "Orchestras"
  end

  test "should load the orchestra" do
    sign_in_as users(:admin)

    visit orchestras_url

    click_on "Juan D'Arienzo"

    assert_selector "h1", text: "Juan D'Arienzo"
  end
end
