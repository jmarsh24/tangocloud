require "application_system_test_case"

class TandasTest < ApplicationSystemTestCase
  test "visiting the index" do
    sign_in_as users(:admin)

    visit tandas_url

    assert_selector "h1", text: "Tandas"
  end

  test "should load the tanda" do
    sign_in_as users(:admin)

    visit tandas_url

    click_on "Juan D'Arienzo Tanda"

    assert_selector "h1", text: "Juan D'Arienzo Tanda"
  end
end
