require "test_helper"

class SearchControllerTest < ActionDispatch::IntegrationTest
  def setup
    @playlist = playlists(:darienzo_essentials)
    @recording = recordings(:la_cumparsita)
    @orchestra = orchestras(:juan_darienzo)
    @tanda = tandas(:juan_darienzo)

    Playlist.reindex
    Recording.reindex
    Orchestra.reindex
    Tanda.reindex
  end

  test "should get index and return correct search results" do
    sign_in_as users(:admin)

    get search_path, params: {query: "darienzo"}

    assert_response :success

    assert_not_nil assigns(:results)
    assert_not_nil assigns(:top_result)
    assert_not_nil assigns(:playlists)
    assert_not_nil assigns(:recordings)
    assert_not_nil assigns(:orchestras)
    assert_not_nil assigns(:tandas)

    assert_includes assigns(:playlists), @playlist
    assert_includes assigns(:recordings), @recording
    assert_includes assigns(:orchestras), @orchestra
    assert_includes assigns(:tandas), @tanda
  end

  test "should return no results for unrelated query" do
    sign_in_as users(:admin)

    get search_path, params: {query: "UnrelatedQuery"}

    assert_response :success

    assert_empty assigns(:results)
    assert_nil assigns(:top_result)
    assert_empty assigns(:playlists)
    assert_empty assigns(:recordings)
    assert_empty assigns(:orchestras)
    assert_empty assigns(:tandas)
  end
end
