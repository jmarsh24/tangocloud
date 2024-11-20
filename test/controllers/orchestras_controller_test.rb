require "test_helper"

class OrchestrasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @orchestra = orchestras(:juan_darienzo)
  end

  test "should display meta_tags for crawler requests" do
    get orchestra_url(@orchestra), headers: {"User-Agent" => "Googlebot"}
    assert_response :success
    assert_template "orchestras/meta_tags"
    assert_select "meta", minimum: 1
  end

  test "should display orchestra show page for non-crawler requests" do
    sign_in_as(users(:tester))
    get orchestra_url(@orchestra), headers: {"User-Agent" => "Mozilla/5.0"}
    assert_response :success
    assert_template "orchestras/show"
    assert_select "h1", @orchestra.display_name
  end

  test "should render turbo_stream for turbo requests" do
    sign_in_as(users(:tester))
    get orchestra_url(@orchestra, format: :turbo_stream), headers: {"User-Agent" => "Mozilla/5.0"}
    assert_response :success
    assert_match "recordings", @response.body
    assert_match "filters", @response.body
  end

  test "should redirect non-logged-in users to root_path if not a bot" do
    get orchestra_url(@orchestra), headers: {"User-Agent" => "Mozilla/5.0"}
    assert_redirected_to sign_in_path
  end
end
