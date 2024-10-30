require "application_system_test_case"

class RecordingsTest < ApplicationSystemTestCase
  test "should load the recording" do
    sign_in_as users(:tester)
    el_choclo = recordings(:el_choclo)

    visit recording_path(el_choclo)

    assert_text "El Choclo"
    assert_text "Juan D'Arienzo"
    assert_text "Lyrics"
  end
end
