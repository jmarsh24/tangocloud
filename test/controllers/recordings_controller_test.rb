require "test_helper"

class RecordingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recording = recordings(:la_cumparsita)
  end

  test "should display meta_tags for crawler requests" do
    get recording_url(@recording), headers: {"User-Agent" => "Googlebot"}
    assert_response :success
    assert_template "recordings/meta_tags"
    assert_select "meta", count: 11
  end

  test "should display playback UI for non-crawler requests" do
    sign_in_as(users(:tester))
    get recording_url(@recording), headers: {"User-Agent" => "Mozilla/5.0"}
    assert_response :success
    assert_template "recordings/show"
    assert_select "#music-player"
  end

  test "should render turbo_stream for turbo requests" do
    sign_in_as(users(:tester))
    get recording_url(@recording, format: :turbo_stream), headers: {"User-Agent" => "Mozilla/5.0"}
    assert_response :success
    assert_match "music-player", @response.body
  end

  test "should redirect non-logged-in users to root_path if not a bot" do
    get recording_url(@recording), headers: {"User-Agent" => "Mozilla/5.0"}

    assert_redirected_to sign_in_path
    follow_redirect!
    assert_response :success
    assert_template "pages/landing"
  end
end
