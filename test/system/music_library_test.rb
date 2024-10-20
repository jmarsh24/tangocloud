require "application_system_test_case"

class MusicLibrariesTest < ApplicationSystemTestCase
  test "visiting the show" do
    sign_in_as users(:admin)

    visit music_library_url

    assert_text "Featured Playlists"
    assert_text "Popular Orchestras"
    assert_text "Trending Recordings"
  end
end
