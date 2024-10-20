require "application_system_test_case"

class PlaylistsTest < ApplicationSystemTestCase
  test "visiting the index" do
    sign_in_as users(:admin)

    visit playlists_url

    assert_selector "h1", text: "Playlists"
  end

  test "should load the playlist" do
    sign_in_as users(:admin)

    visit playlists_url

    click_on "D'Arienzo Essentials"

    assert_selector "h1", text: "D'Arienzo Essentials"
  end
end
