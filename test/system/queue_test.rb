require "application_system_test_case"

class QueueTest < ApplicationSystemTestCase
  test "adding a recording to the queue" do
    orchestra = orchestras(:juan_darienzo)
    sign_in_as users(:tester)

    visit orchestra_path(orchestra)

    assert_selector "h1", text: "Juan D'Arienzo"

    find_button("La Cumparsita", visible: false, match: :first).click

    assert_selector "#music-player", text: "La Cumparsita"

    click_on "Add to queue"

    assert_selector "#now-playing", text: "La Cumparsita"
    assert_selector "#queue-items", text: "El Choclo"
  end
end
