require "test_helper"

class PwaControllerTest < ActionDispatch::IntegrationTest
  test "should get manifest" do
    get pwa_manifest_url, as: :json

    assert_response :success
    assert_match %r{application/json}, @response.content_type

    assert_match(/"name": "TangoCloud"/, @response.body)
  end
end
