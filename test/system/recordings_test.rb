require "application_system_test_case"

class RecordingsTest < ApplicationSystemTestCase
  test "visiting the index" do
    sign_in_as users(:admin) do
      visit recordings_url

      click_on "Recordings"

      assert_selector "h1", text: "Recordings"
    end
  end

  test "should load the recording" do
    sign_in_as users(:admin) do
      visit recordings_url

      click_on "La Cumparsita"

      within "#music-player" do
        assert_text "La Cumparsita"
      end
    end
  end
end
